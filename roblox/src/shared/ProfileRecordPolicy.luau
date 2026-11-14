--!strict
-- Pure transformations for the versioned DataStore record.
-- Call these only from DataStore UpdateAsync callbacks; this module performs no I/O.

local ProfileRecordPolicy = {}

local function isRecord(value: unknown): boolean
	return typeof(value) == "table"
end

local function copyProfile(profile: any)
	local copy = table.clone(profile)
	copy.identity = table.clone(profile.identity)
	copy.progression = table.clone(profile.progression)
	copy.progression.completedEvaluations = table.clone(profile.progression.completedEvaluations)
	copy.progression.completedMissionIds = table.clone(profile.progression.completedMissionIds)
	copy.economy = table.clone(profile.economy)
	copy.economy.recentTransactions = table.clone(profile.economy.recentTransactions)
	for index, transaction in copy.economy.recentTransactions do
		copy.economy.recentTransactions[index] = table.clone(transaction)
	end
	copy.companions = table.clone(profile.companions)
	copy.companions.owned = table.clone(profile.companions.owned)
	copy.inventory = table.clone(profile.inventory)
	copy.inventory.items = table.clone(profile.inventory.items)
	copy.investigation = table.clone(profile.investigation)
	copy.investigation.ridgeview = table.clone(profile.investigation.ridgeview)
	copy.investigation.ridgeview.observations = table.clone(profile.investigation.ridgeview.observations)
	return copy
end

local function deepEqual(left: any, right: any): boolean
	if left == right then
		return true
	end
	if typeof(left) ~= "table" or typeof(right) ~= "table" then
		return false
	end

	for key, value in left do
		if not deepEqual(value, right[key]) then
			return false
		end
	end
	for key in right do
		if left[key] == nil then
			return false
		end
	end
	return true
end

local function copySaveOperation(operation: any)
	if operation == nil then
		return nil
	end
	return {
		id = operation.id,
		ownerToken = operation.ownerToken,
		baseRevision = operation.baseRevision,
		resultRevision = operation.resultRevision,
	}
end

local function isValidSaveOperation(operation: unknown): boolean
	if operation == nil then
		return true
	end
	if typeof(operation) ~= "table" then
		return false
	end
	local value = operation :: any
	return typeof(value.id) == "string"
		and value.id ~= ""
		and #value.id <= 128
		and typeof(value.ownerToken) == "string"
		and value.ownerToken ~= ""
		and typeof(value.baseRevision) == "number"
		and value.baseRevision >= 0
		and value.baseRevision % 1 == 0
		and typeof(value.resultRevision) == "number"
		and value.resultRevision == value.baseRevision + 1
end

function ProfileRecordPolicy.TryAcquire(
	existingRecord: unknown,
	ownerToken: string,
	now: number,
	leaseDuration: number,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any,
	leasePolicy: any
): (any?, string?)
	local profile
	local existingLease = nil
	local lastSaveOperation = nil

	if existingRecord == nil then
		profile = profileSchema.CreateDefault()
	elseif not isRecord(existingRecord) then
		return nil, "Stored profile record is malformed."
	else
		local record = existingRecord :: any
		if record.profile == nil then
			return nil, "Stored profile is missing."
		end
		if not isValidSaveOperation(record.lastSaveOperation) then
			return nil, "Stored save-operation marker is malformed."
		end
		local migratedProfile, migrationError = profileSchema.Migrate(
			record.profile,
			rankCatalog,
			companionCatalog,
			inventoryPolicy,
			itemCatalog
		)
		if migratedProfile == nil then
			return nil, migrationError or "Stored profile failed validation or migration."
		end
		profile = migratedProfile
		existingLease = record.lease
		lastSaveOperation = copySaveOperation(record.lastSaveOperation)
	end

	local lease, leaseError = leasePolicy.TryAcquire(existingLease, ownerToken, now, leaseDuration)
	if lease == nil then
		return nil, leaseError or "Profile lease could not be acquired."
	end

	return {
		profile = profile,
		lease = lease,
		lastSaveOperation = lastSaveOperation,
	}, nil
end

function ProfileRecordPolicy.TrySave(
	existingRecord: unknown,
	ownerToken: string,
	now: number,
	leaseDuration: number,
	candidateProfile: unknown,
	operationId: string,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any,
	leasePolicy: any
): (any?, string?, string?)
	if not isRecord(existingRecord) then
		return nil, "Stored profile record is missing or malformed.", nil
	end
	local record = existingRecord :: any
	if record.profile == nil then
		return nil, "Stored profile record is missing or malformed.", nil
	end
	if not isValidSaveOperation(record.lastSaveOperation) then
		return nil, "Stored save-operation marker is malformed.", nil
	end

	if typeof(operationId) ~= "string" or operationId == "" or #operationId > 128 then
		return nil, "Save operation ID must be a non-empty string of at most 128 characters.", nil
	end

	local candidateValid, candidateError = profileSchema.Validate(candidateProfile, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog)
	if not candidateValid then
		return nil, candidateError or "Candidate profile failed validation.", nil
	end
	local storedValid = profileSchema.Validate(record.profile, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog)
	if not storedValid then
		return nil, "Stored profile failed validation; refusing to overwrite it.", nil
	end

	local candidate = candidateProfile :: any
	local storedProfile = record.profile
	local previousOperation = record.lastSaveOperation

	-- A retry after an ambiguous UpdateAsync result is successful only when the
	-- operation ID, owner, base revision and complete resulting profile all match.
	if typeof(previousOperation) == "table" and previousOperation.id == operationId then
		local expectedProfile = copyProfile(candidate)
		expectedProfile.revision = candidate.revision + 1
		local exactMatch = previousOperation.ownerToken == ownerToken
			and previousOperation.baseRevision == candidate.revision
			and previousOperation.resultRevision == expectedProfile.revision
			and storedProfile.revision == expectedProfile.revision
			and deepEqual(storedProfile, expectedProfile)
		if exactMatch then
			return record, nil, "AlreadyApplied"
		end
		return nil, "Save operation ID was reused with a different owner, revision or payload.", nil
	end

	if not leasePolicy.IsOwner(record.lease, ownerToken, now) then
		return nil, "This server no longer owns the profile lease.", nil
	end
	if candidate.revision ~= storedProfile.revision then
		return nil, "Profile revision conflict; refusing to overwrite newer data.", nil
	end

	local savedProfile = copyProfile(candidate)
	savedProfile.revision = storedProfile.revision + 1
	local lease, leaseError = leasePolicy.TryAcquire(record.lease, ownerToken, now, leaseDuration)
	if lease == nil then
		return nil, leaseError or "Profile lease renewal failed during save.", nil
	end

	return {
		profile = savedProfile,
		lease = lease,
		lastSaveOperation = {
			id = operationId,
			ownerToken = ownerToken,
			baseRevision = candidate.revision,
			resultRevision = savedProfile.revision,
		},
	}, nil, "Saved"
end

function ProfileRecordPolicy.TryRelease(
	existingRecord: unknown,
	ownerToken: string,
	leasePolicy: any
): (any?, string?)
	if not isRecord(existingRecord) then
		return nil, "Stored profile record is missing or malformed."
	end
	local record = existingRecord :: any
	if record.profile == nil then
		return nil, "Stored profile record is missing or malformed."
	end
	if not isValidSaveOperation(record.lastSaveOperation) then
		return nil, "Stored save-operation marker is malformed."
	end

	local released, retainedLease = leasePolicy.TryRelease(record.lease, ownerToken)
	if not released then
		return nil, "This server cannot release a lease owned by another server."
	end

	return {
		profile = record.profile,
		lease = retainedLease,
		lastSaveOperation = copySaveOperation(record.lastSaveOperation),
	}, nil
end

return table.freeze(ProfileRecordPolicy)
