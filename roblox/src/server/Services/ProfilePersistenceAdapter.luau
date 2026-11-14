--!strict
-- Injectable profile persistence adapter.
-- This module is intentionally NOT wired into player joins. It requires a DataStore-like
-- object and explicit dependencies so its retry and recovery behavior can be tested offline.

local ProfilePersistenceAdapter = {}
ProfilePersistenceAdapter.__index = ProfilePersistenceAdapter

type Options = {
	Store: any,
	ProfileSchema: any,
	RankCatalog: any,
	CompanionCatalog: any,
	InventoryPolicy: any,
	ItemCatalog: any,
	IdentityPolicy: any,
	LeasePolicy: any,
	RecordPolicy: any,
	Clock: () -> number,
	Wait: (number) -> (),
	GenerateToken: () -> string,
	Random: () -> number,
	MaxAttempts: number?,
	BaseDelaySeconds: number?,
	LeaseDurationSeconds: number?,
}

local function isPositiveInteger(value: unknown): boolean
	return typeof(value) == "number" and value == value and value ~= math.huge and value > 0 and value % 1 == 0
end

local function cloneValue(value: any): any
	if typeof(value) ~= "table" then
		return value
	end
	local copy = {}
	for key, item in value do
		copy[cloneValue(key)] = cloneValue(item)
	end
	return copy
end

local function isTransientError(value: unknown): boolean
	local message = string.lower(tostring(value))
	local markers = {
		"temporar",
		"timeout",
		"throttl",
		"queue",
		"http 5",
		"response loss",
		"service unavailable",
		"internal error",
		"429",
		"502",
		"503",
		"504",
	}
	for _, marker in markers do
		if string.find(message, marker, 1, true) ~= nil then
			return true
		end
	end
	return false
end

function ProfilePersistenceAdapter.new(options: Options)
	assert(typeof(options) == "table", "Adapter options are required.")
	assert(options.Store ~= nil, "A DataStore-like Store is required.")
	assert(options.ProfileSchema ~= nil and options.RankCatalog ~= nil and options.CompanionCatalog ~= nil, "Profile validation dependencies are required.")
	assert(options.IdentityPolicy ~= nil, "Player identity validation dependency is required.")
	assert(options.InventoryPolicy ~= nil and options.ItemCatalog ~= nil, "Inventory validation dependencies are required.")
	assert(options.LeasePolicy ~= nil and options.RecordPolicy ~= nil, "Profile record policy dependencies are required.")
	assert(typeof(options.Clock) == "function", "Clock dependency is required.")
	assert(typeof(options.Wait) == "function", "Wait dependency is required.")
	assert(typeof(options.GenerateToken) == "function", "GenerateToken dependency is required.")
	assert(typeof(options.Random) == "function", "Random dependency is required.")

	local maxAttempts = options.MaxAttempts or 3
	local baseDelay = options.BaseDelaySeconds or 0.25
	local leaseDuration = options.LeaseDurationSeconds or 120
	assert(isPositiveInteger(maxAttempts) and maxAttempts <= 5, "MaxAttempts must be an integer from 1 to 5.")
	assert(typeof(baseDelay) == "number" and baseDelay == baseDelay and baseDelay ~= math.huge and baseDelay >= 0, "BaseDelaySeconds must be finite and non-negative.")
	assert(
		typeof(leaseDuration) == "number" and leaseDuration == leaseDuration and leaseDuration ~= math.huge and leaseDuration >= 30,
		"LeaseDurationSeconds must be finite and at least 30."
	)

	return setmetatable({
		store = options.Store,
		profileSchema = options.ProfileSchema,
		rankCatalog = options.RankCatalog,
		companionCatalog = options.CompanionCatalog,
		inventoryPolicy = options.InventoryPolicy,
		itemCatalog = options.ItemCatalog,
		identityPolicy = options.IdentityPolicy,
		leasePolicy = options.LeasePolicy,
		recordPolicy = options.RecordPolicy,
		clock = options.Clock,
		wait = options.Wait,
		generateToken = options.GenerateToken,
		random = options.Random,
		maxAttempts = maxAttempts,
		baseDelaySeconds = baseDelay,
		leaseDurationSeconds = leaseDuration,
	}, ProfilePersistenceAdapter)
end

function ProfilePersistenceAdapter.GetKeyForUser(userId: unknown): string?
	if not isPositiveInteger(userId) then
		return nil
	end
	return "player:" .. tostring(userId)
end

function ProfilePersistenceAdapter:_UpdateWithRetry(key: string, buildTransform: (number, (string?, string?) -> ()) -> (any) -> any): (any?, string?, string?)
	for attempt = 1, self.maxAttempts do
		local now = self.clock()
		local callbackError: string? = nil
		local callbackOutcome: string? = nil
		local function setCallbackResult(errorMessage: string?, outcome: string?)
			callbackError = errorMessage
			callbackOutcome = outcome
		end
		local transform = buildTransform(now, setCallbackResult)
		local ok, updatedRecord, storeError = pcall(function()
			return self.store:UpdateAsync(key, transform)
		end)

		if ok and storeError == nil and updatedRecord ~= nil then
			return updatedRecord, nil, callbackOutcome
		end

		local failure: unknown
		if not ok then
			failure = updatedRecord
		elseif storeError ~= nil then
			failure = storeError
		else
			-- A nil UpdateAsync result with no storage error means the policy cancelled
			-- the write. Treat its domain reason as terminal, never as a retryable outage.
			return nil, callbackError or "Profile update was cancelled without a policy reason.", nil
		end

		if not isTransientError(failure) or attempt == self.maxAttempts then
			return nil, tostring(failure), nil
		end

		local exponentialDelay = self.baseDelaySeconds * (2 ^ (attempt - 1))
		local randomValue = self.random()
		local normalizedRandom = if randomValue == randomValue then math.max(0, math.min(1, randomValue)) else 0
		local jitter = normalizedRandom * self.baseDelaySeconds
		self.wait(exponentialDelay + jitter)
	end

	return nil, "Profile update exhausted its retry budget.", nil
end

function ProfilePersistenceAdapter:Acquire(userId: unknown): (any?, string?)
	local key = ProfilePersistenceAdapter.GetKeyForUser(userId)
	if key == nil then
		return nil, "User ID must be a positive integer."
	end

	local ownerToken = self.generateToken()
	if typeof(ownerToken) ~= "string" or ownerToken == "" or #ownerToken > 128 then
		return nil, "Session owner token generation failed."
	end

	local updatedRecord, updateError = self:_UpdateWithRetry(key, function(now, setCallbackResult)
		return function(existingRecord)
			local nextRecord, policyError = self.recordPolicy.TryAcquire(
				existingRecord,
				ownerToken,
				now,
				self.leaseDurationSeconds,
				self.profileSchema,
				self.rankCatalog,
				self.companionCatalog,
				self.inventoryPolicy,
				self.itemCatalog,
				self.leasePolicy,
				self.identityPolicy
			)
			setCallbackResult(policyError, nil)
			return nextRecord
		end
	end)

	if updatedRecord == nil then
		return nil, updateError
	end

	return {
		profile = cloneValue(updatedRecord.profile),
		ownerToken = ownerToken,
		revision = updatedRecord.profile.revision,
		leaseExpiresAt = updatedRecord.lease.expiresAt,
	},
		nil
end

function ProfilePersistenceAdapter:Save(userId: unknown, ownerToken: unknown, candidateProfile: unknown, operationId: unknown): (any?, string?)
	local key = ProfilePersistenceAdapter.GetKeyForUser(userId)
	if key == nil then
		return nil, "User ID must be a positive integer."
	end
	if typeof(ownerToken) ~= "string" or ownerToken == "" or #ownerToken > 128 then
		return nil, "A valid session owner token is required."
	end
	if typeof(operationId) ~= "string" or operationId == "" or #operationId > 128 then
		return nil, "A unique save operation ID is required."
	end

	local updatedRecord, updateError, outcome = self:_UpdateWithRetry(key, function(now, setCallbackResult)
		return function(existingRecord)
			local nextRecord, policyError, policyOutcome = self.recordPolicy.TrySave(
				existingRecord,
				ownerToken,
				now,
				self.leaseDurationSeconds,
				candidateProfile,
				operationId,
				self.profileSchema,
				self.rankCatalog,
				self.companionCatalog,
				self.inventoryPolicy,
				self.itemCatalog,
				self.leasePolicy,
				self.identityPolicy
			)
			setCallbackResult(policyError, policyOutcome)
			return nextRecord
		end
	end)

	if updatedRecord == nil then
		return nil, updateError
	end

	return {
		profile = cloneValue(updatedRecord.profile),
		revision = updatedRecord.profile.revision,
		outcome = outcome or "Saved",
	}, nil
end

function ProfilePersistenceAdapter:Release(userId: unknown, ownerToken: unknown): (boolean, string?)
	local key = ProfilePersistenceAdapter.GetKeyForUser(userId)
	if key == nil then
		return false, "User ID must be a positive integer."
	end
	if typeof(ownerToken) ~= "string" or ownerToken == "" or #ownerToken > 128 then
		return false, "A valid session owner token is required."
	end

	local updatedRecord, updateError = self:_UpdateWithRetry(key, function(_now, setCallbackResult)
		return function(existingRecord)
			local nextRecord, policyError = self.recordPolicy.TryRelease(existingRecord, ownerToken, self.leasePolicy)
			setCallbackResult(policyError, nil)
			return nextRecord
		end
	end)

	if updatedRecord == nil then
		return false, updateError
	end
	return true, nil
end

return table.freeze(ProfilePersistenceAdapter)
