--!strict
-- Pure NPC merchant transactions. The caller must supply server-configured prices;
-- never pass a price or item definition received from a client.

local MerchantTransactionPolicy = {}

local MAX_CURRENCY_BALANCE = 2_000_000_000
local MAX_TRANSACTION_ID_LENGTH = 128
local MAX_RECENT_TRANSACTIONS = 50

local function isPositiveInteger(value: unknown): boolean
	return typeof(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge and value > 0 and value % 1 == 0
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
	return copy
end

local function findPriorTransaction(profile: any, transactionId: string): any?
	for _, transaction in profile.economy.recentTransactions do
		if transaction.id == transactionId then
			return transaction
		end
	end
	return nil
end

local function transactionMatches(transaction: any, kind: string, itemId: string, quantity: number, unitPrice: number): boolean
	local expectedDelta = if kind == "MerchantPurchase" then -(quantity * unitPrice) else quantity * unitPrice
	return transaction.kind == kind
		and transaction.itemId == itemId
		and transaction.quantity == quantity
		and transaction.unitPrice == unitPrice
		and transaction.acesDelta == expectedDelta
end

local function validateRequest(
	profile: unknown,
	itemId: unknown,
	quantity: unknown,
	unitPrice: unknown,
	transactionId: unknown,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any,
	identityPolicy: any
): (any?, string?)
	local validProfile, profileError = profileSchema.Validate(profile, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog, identityPolicy)
	if not validProfile then
		return nil, profileError or "Player profile is invalid."
	end
	if typeof(transactionId) ~= "string" or transactionId == "" or #transactionId > MAX_TRANSACTION_ID_LENGTH then
		return nil, "Transaction ID must be a non-empty string of at most 128 characters."
	end
	if typeof(itemId) ~= "string" or itemCatalog[itemId] == nil then
		return nil, "Unknown item."
	end
	local definition = itemCatalog[itemId]
	if definition.Tradeable ~= true or typeof(definition.MerchantGroup) ~= "string" then
		return nil, "This item cannot be traded with merchants."
	end
	if not isPositiveInteger(quantity) then
		return nil, "Quantity must be a positive whole number."
	end
	if not isPositiveInteger(unitPrice) then
		return nil, "The server-configured unit price is invalid."
	end
	local total = (quantity :: number) * (unitPrice :: number)
	if total > MAX_CURRENCY_BALANCE or total % 1 ~= 0 then
		return nil, "Transaction value exceeds the supported currency limit."
	end
	return {
		profile = profile,
		itemId = itemId,
		quantity = quantity,
		unitPrice = unitPrice,
		total = total,
		transactionId = transactionId,
	}, nil
end

local function applyTransaction(
	profile: any,
	kind: string,
	itemId: string,
	quantity: number,
	unitPrice: number,
	transactionId: string,
	newInventory: any,
	acesDelta: number,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any,
	identityPolicy: any
): (any?, string?, string?)
	local prior = findPriorTransaction(profile, transactionId)
	if prior ~= nil then
		if transactionMatches(prior, kind, itemId, quantity, unitPrice) then
			return copyProfile(profile), nil, "AlreadyApplied"
		end
		return nil, "Transaction ID was reused with a different payload.", nil
	end

	local nextBalance = profile.economy.aces + acesDelta
	if nextBalance < 0 then
		return nil, "Insufficient Aces.", nil
	end
	if nextBalance > MAX_CURRENCY_BALANCE then
		return nil, "Aces balance would exceed the supported limit.", nil
	end

	local updated = copyProfile(profile)
	updated.inventory = newInventory
	updated.economy.aces = nextBalance
	table.insert(updated.economy.recentTransactions, {
		id = transactionId,
		kind = kind,
		itemId = itemId,
		quantity = quantity,
		unitPrice = unitPrice,
		acesDelta = acesDelta,
	})
	while #updated.economy.recentTransactions > MAX_RECENT_TRANSACTIONS do
		table.remove(updated.economy.recentTransactions, 1)
	end

	local validUpdated, updatedError = profileSchema.Validate(updated, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog, identityPolicy)
	if not validUpdated then
		return nil, updatedError or "Transaction produced an invalid profile.", nil
	end
	return updated, nil, "Applied"
end

function MerchantTransactionPolicy.TryPurchase(
	profile: unknown,
	itemId: unknown,
	quantity: unknown,
	serverUnitPrice: unknown,
	transactionId: unknown,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any,
	identityPolicy: any
): (any?, string?, string?)
	local request, requestError =
		validateRequest(profile, itemId, quantity, serverUnitPrice, transactionId, profileSchema, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog, identityPolicy)
	if request == nil then
		return nil, requestError, nil
	end

	local value = request :: any
	local currentProfile = value.profile
	local prior = findPriorTransaction(currentProfile, value.transactionId)
	if prior ~= nil then
		if transactionMatches(prior, "MerchantPurchase", value.itemId, value.quantity, value.unitPrice) then
			return copyProfile(currentProfile), nil, "AlreadyApplied"
		end
		return nil, "Transaction ID was reused with a different payload.", nil
	end

	local newInventory, inventoryError = inventoryPolicy.TryAdd(currentProfile.inventory, value.itemId, value.quantity, itemCatalog)
	if newInventory == nil then
		return nil, inventoryError or "Inventory cannot accept this purchase.", nil
	end
	return applyTransaction(
		currentProfile,
		"MerchantPurchase",
		value.itemId,
		value.quantity,
		value.unitPrice,
		value.transactionId,
		newInventory,
		-value.total,
		profileSchema,
		rankCatalog,
		companionCatalog,
		inventoryPolicy,
		itemCatalog,
		identityPolicy
	)
end

function MerchantTransactionPolicy.TrySell(
	profile: unknown,
	itemId: unknown,
	quantity: unknown,
	serverUnitPrice: unknown,
	transactionId: unknown,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any,
	identityPolicy: any
): (any?, string?, string?)
	local request, requestError =
		validateRequest(profile, itemId, quantity, serverUnitPrice, transactionId, profileSchema, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog, identityPolicy)
	if request == nil then
		return nil, requestError, nil
	end

	local value = request :: any
	local currentProfile = value.profile
	local prior = findPriorTransaction(currentProfile, value.transactionId)
	if prior ~= nil then
		if transactionMatches(prior, "MerchantSale", value.itemId, value.quantity, value.unitPrice) then
			return copyProfile(currentProfile), nil, "AlreadyApplied"
		end
		return nil, "Transaction ID was reused with a different payload.", nil
	end

	local newInventory, inventoryError = inventoryPolicy.TryRemove(currentProfile.inventory, value.itemId, value.quantity, itemCatalog)
	if newInventory == nil then
		return nil, inventoryError or "Inventory does not contain the requested items.", nil
	end
	return applyTransaction(
		currentProfile,
		"MerchantSale",
		value.itemId,
		value.quantity,
		value.unitPrice,
		value.transactionId,
		newInventory,
		value.total,
		profileSchema,
		rankCatalog,
		companionCatalog,
		inventoryPolicy,
		itemCatalog,
		identityPolicy
	)
end

return table.freeze(MerchantTransactionPolicy)
