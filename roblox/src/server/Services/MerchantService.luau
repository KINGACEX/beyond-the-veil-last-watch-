--!strict
-- Server-only NPC merchant transaction coordinator.
-- Offer prices are injected from trusted server configuration; clients never submit prices.
-- This service is not connected to remotes or live joins until profile lifecycle integration is approved.

local MerchantService = {}
MerchantService.__index = MerchantService

type Options = {
	Offers: any,
	GetSession: (any) -> any?,
	PersistenceAdapter: any,
	TransactionPolicy: any,
	ProfileSchema: any,
	RankCatalog: any,
	CompanionCatalog: any,
	InventoryPolicy: any,
	ItemCatalog: any,
	Clock: () -> number,
	MinimumRequestIntervalSeconds: number?,
}

local function isPositiveInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value > 0
		and value % 1 == 0
end

local function isValidRequestId(value: unknown): boolean
	return typeof(value) == "string"
		and #value >= 8
		and #value <= 64
		and string.match(value, "^[%w_%-]+$") ~= nil
end

function MerchantService.new(options: Options)
	assert(typeof(options) == "table", "Merchant service options are required.")
	assert(typeof(options.Offers) == "table", "Trusted server merchant offers are required.")
	assert(typeof(options.GetSession) == "function", "Profile session lookup is required.")
	assert(options.PersistenceAdapter ~= nil, "Persistence adapter is required.")
	assert(options.TransactionPolicy ~= nil, "Merchant transaction policy is required.")
	assert(typeof(options.Clock) == "function", "Clock dependency is required.")

	local minimumInterval = options.MinimumRequestIntervalSeconds or 0.25
	assert(
		typeof(minimumInterval) == "number"
			and minimumInterval == minimumInterval
			and minimumInterval ~= math.huge
			and minimumInterval >= 0,
		"Minimum request interval must be finite and non-negative."
	)

	return setmetatable({
		offers = options.Offers,
		getSession = options.GetSession,
		persistenceAdapter = options.PersistenceAdapter,
		transactionPolicy = options.TransactionPolicy,
		profileSchema = options.ProfileSchema,
		rankCatalog = options.RankCatalog,
		companionCatalog = options.CompanionCatalog,
		inventoryPolicy = options.InventoryPolicy,
		itemCatalog = options.ItemCatalog,
		clock = options.Clock,
		minimumRequestIntervalSeconds = minimumInterval,
		lastRequestAt = {},
		busy = {},
	}, MerchantService)
end

function MerchantService:_Transact(
	player: any,
	kind: string,
	merchantId: unknown,
	itemId: unknown,
	quantity: unknown,
	requestId: unknown
): (any?, string?)
	if typeof(player) ~= "table" and typeof(player) ~= "Instance" then
		return nil, "A valid player is required."
	end
	local userId = player.UserId
	if not isPositiveInteger(userId) then
		return nil, "Player user ID is invalid."
	end

	local now = self.clock()
	if typeof(now) ~= "number" or now ~= now or now == math.huge or now == -math.huge then
		return nil, "Merchant service clock is invalid."
	end
	local previousRequestAt = self.lastRequestAt[userId]
	if previousRequestAt ~= nil and now - previousRequestAt < self.minimumRequestIntervalSeconds then
		return nil, "Please wait before making another merchant request."
	end
	self.lastRequestAt[userId] = now

	if self.busy[userId] then
		return nil, "A merchant transaction is already being processed."
	end
	if not isValidRequestId(requestId) then
		return nil, "Request ID must be 8–64 letters, numbers, underscores or hyphens."
	end
	if typeof(merchantId) ~= "string" or typeof(itemId) ~= "string" then
		return nil, "Merchant and item IDs must be valid strings."
	end
	if not isPositiveInteger(quantity) then
		return nil, "Quantity must be a positive whole number."
	end

	local merchant = self.offers[merchantId]
	if typeof(merchant) ~= "table" then
		return nil, "Merchant is not available."
	end
	local priceTable = if kind == "MerchantPurchase" then merchant.BuyPrices else merchant.SellPrices
	if typeof(priceTable) ~= "table" or not isPositiveInteger(priceTable[itemId]) then
		return nil, "This item is not offered for the requested transaction."
	end
	local unitPrice = priceTable[itemId]

	self.busy[userId] = true
	local ok, result, transactionError = pcall(function()
		local session = self.getSession(player)
		if typeof(session) ~= "table"
			or typeof(session.ownerToken) ~= "string"
			or session.ownerToken == ""
			or typeof(session.profile) ~= "table"
		then
			return nil, "Player profile session is unavailable."
		end

		local transactionId = "merchant:" .. tostring(userId) .. ":" .. requestId
		local saveOperationId = "merchant-save:" .. tostring(userId) .. ":" .. requestId
		local updatedProfile, policyError, policyOutcome
		if kind == "MerchantPurchase" then
			updatedProfile, policyError, policyOutcome = self.transactionPolicy.TryPurchase(
				session.profile,
				itemId,
				quantity,
				unitPrice,
				transactionId,
				self.profileSchema,
				self.rankCatalog,
				self.companionCatalog,
				self.inventoryPolicy,
				self.itemCatalog
			)
		else
			updatedProfile, policyError, policyOutcome = self.transactionPolicy.TrySell(
				session.profile,
				itemId,
				quantity,
				unitPrice,
				transactionId,
				self.profileSchema,
				self.rankCatalog,
				self.companionCatalog,
				self.inventoryPolicy,
				self.itemCatalog
			)
		end

		if updatedProfile == nil then
			return nil, policyError or "Merchant transaction was rejected."
		end

		local saveResult = nil
		if policyOutcome == "AlreadyApplied" then
			saveResult = {
				profile = updatedProfile,
				revision = updatedProfile.revision,
				outcome = "AlreadyApplied",
			}
		else
			local saveError
			saveResult, saveError = self.persistenceAdapter:Save(
				userId,
				session.ownerToken,
				updatedProfile,
				saveOperationId
			)
			if saveResult == nil then
				return nil, saveError or "Merchant transaction could not be committed."
			end
		end

		session.profile = saveResult.profile
		session.revision = saveResult.revision
		local journalEntry = nil
		for _, entry in saveResult.profile.economy.recentTransactions do
			if entry.id == transactionId then
				journalEntry = entry
				break
			end
		end
		if journalEntry == nil then
			return nil, "Committed merchant transaction is missing its journal receipt."
		end

		return {
			transactionId = transactionId,
			merchantId = merchantId,
			kind = journalEntry.kind,
			itemId = journalEntry.itemId,
			quantity = journalEntry.quantity,
			unitPrice = journalEntry.unitPrice,
			acesDelta = journalEntry.acesDelta,
			balance = saveResult.profile.economy.aces,
			revision = saveResult.revision,
			outcome = if saveResult.outcome == "AlreadyApplied" then "AlreadyApplied" else policyOutcome,
		}, nil
	end)
	self.busy[userId] = nil

	if not ok then
		return nil, "Merchant transaction failed safely: " .. tostring(result)
	end
	return result, transactionError
end

function MerchantService:Purchase(
	player: any,
	merchantId: unknown,
	itemId: unknown,
	quantity: unknown,
	requestId: unknown
): (any?, string?)
	return self:_Transact(player, "MerchantPurchase", merchantId, itemId, quantity, requestId)
end

function MerchantService:Sell(
	player: any,
	merchantId: unknown,
	itemId: unknown,
	quantity: unknown,
	requestId: unknown
): (any?, string?)
	return self:_Transact(player, "MerchantSale", merchantId, itemId, quantity, requestId)
end

function MerchantService:RemovePlayer(player: any)
	if typeof(player) == "table" or typeof(player) == "Instance" then
		local userId = player.UserId
		if isPositiveInteger(userId) then
			self.lastRequestAt[userId] = nil
		end
	end
end

return table.freeze(MerchantService)
