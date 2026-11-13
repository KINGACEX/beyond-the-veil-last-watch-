--!strict
-- Pure inventory validation and transformations. No DataStore or Roblox service access.

local InventoryPolicy = {}

local MAX_DISTINCT_ITEMS = 30

local function isPositiveInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value > 0
		and value % 1 == 0
end

local function copyInventory(inventory: any)
	return {
		items = table.clone(inventory.items),
	}
end

local function getDefinition(itemId: unknown, catalog: any): any?
	if typeof(itemId) ~= "string" then
		return nil
	end
	return catalog[itemId]
end

function InventoryPolicy.CreateDefault()
	return {
		items = {},
	}
end

function InventoryPolicy.Validate(inventory: unknown, catalog: any): (boolean, string?)
	if typeof(inventory) ~= "table" or typeof(inventory.items) ~= "table" then
		return false, "Inventory structure is malformed."
	end

	local distinctCount = 0
	for itemId, quantity in inventory.items do
		if typeof(itemId) ~= "string" then
			return false, "Inventory contains a malformed item ID."
		end
		local definition = getDefinition(itemId, catalog)
		if definition == nil then
			return false, "Inventory contains an unknown item."
		end
		if not isPositiveInteger(quantity) or quantity > definition.MaxStack then
			return false, "Inventory contains an invalid item quantity."
		end
		distinctCount += 1
	end

	if distinctCount > MAX_DISTINCT_ITEMS then
		return false, "Inventory exceeds the distinct-item limit."
	end

	return true, nil
end

function InventoryPolicy.TryAdd(inventory: unknown, itemId: unknown, quantity: unknown, catalog: any): (any?, string?)
	local valid, validationError = InventoryPolicy.Validate(inventory, catalog)
	if not valid then
		return nil, validationError
	end

	local definition = getDefinition(itemId, catalog)
	if definition == nil then
		return nil, "Unknown item."
	end
	if not isPositiveInteger(quantity) then
		return nil, "Item quantity must be a positive whole number."
	end

	local currentInventory = inventory :: any
	local currentQuantity = currentInventory.items[itemId] or 0
	if currentQuantity + (quantity :: number) > definition.MaxStack then
		return nil, "Item stack limit would be exceeded."
	end
	if currentQuantity == 0 then
		local distinctCount = 0
		for _ in currentInventory.items do
			distinctCount += 1
		end
		if distinctCount >= MAX_DISTINCT_ITEMS then
			return nil, "Inventory has no free item slots."
		end
	end

	local updated = copyInventory(currentInventory)
	updated.items[itemId :: string] = currentQuantity + (quantity :: number)
	return updated, nil
end

function InventoryPolicy.TryRemove(inventory: unknown, itemId: unknown, quantity: unknown, catalog: any): (any?, string?)
	local valid, validationError = InventoryPolicy.Validate(inventory, catalog)
	if not valid then
		return nil, validationError
	end

	if getDefinition(itemId, catalog) == nil then
		return nil, "Unknown item."
	end
	if not isPositiveInteger(quantity) then
		return nil, "Item quantity must be a positive whole number."
	end

	local currentInventory = inventory :: any
	local currentQuantity = currentInventory.items[itemId] or 0
	if currentQuantity < (quantity :: number) then
		return nil, "Insufficient item quantity."
	end

	local updated = copyInventory(currentInventory)
	local remaining = currentQuantity - (quantity :: number)
	if remaining == 0 then
		updated.items[itemId :: string] = nil
	else
		updated.items[itemId :: string] = remaining
	end
	return updated, nil
end

return table.freeze(InventoryPolicy)
