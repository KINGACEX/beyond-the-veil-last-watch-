--!strict
-- Pure parcel ownership rules. No DataStore, networking or Roblox service access.

local PropertyPolicy = {}

local function isPositiveInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value > 0
		and value % 1 == 0
end

local function isNonNegativeInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value >= 0
		and value % 1 == 0
end

local function copyParcel(parcel: any)
	return {
		parcelId = parcel.parcelId,
		regionId = parcel.regionId,
		propertyType = parcel.propertyType,
		ownerUserId = parcel.ownerUserId,
		revision = parcel.revision,
		width = parcel.width,
		depth = parcel.depth,
		maxLayer = parcel.maxLayer,
		maxObjects = parcel.maxObjects,
		objects = table.clone(parcel.objects),
	}
end

function PropertyPolicy.CreateState(parcelId: unknown, catalog: any): (any?, string?)
	if typeof(parcelId) ~= "string" or typeof(catalog[parcelId]) ~= "table" then
		return nil, "Unknown parcel definition."
	end
	local definition = catalog[parcelId]
	return {
		parcelId = definition.Id,
		regionId = definition.RegionId,
		propertyType = definition.PropertyType,
		ownerUserId = nil,
		revision = 0,
		width = definition.Width,
		depth = definition.Depth,
		maxLayer = definition.MaxLayer,
		maxObjects = definition.MaxObjects,
		objects = {},
	}, nil
end

function PropertyPolicy.Validate(parcel: unknown): (boolean, string?)
	if typeof(parcel) ~= "table" then
		return false, "Parcel state must be a table."
	end
	local value = parcel :: any
	if typeof(value.parcelId) ~= "string"
		or typeof(value.regionId) ~= "string"
		or typeof(value.propertyType) ~= "string"
		or not isNonNegativeInteger(value.revision)
		or not isPositiveInteger(value.width)
		or not isPositiveInteger(value.depth)
		or not isNonNegativeInteger(value.maxLayer)
		or not isPositiveInteger(value.maxObjects)
		or typeof(value.objects) ~= "table"
	then
		return false, "Parcel state contains malformed metadata."
	end
	if value.ownerUserId ~= nil and not isPositiveInteger(value.ownerUserId) then
		return false, "Parcel owner ID is malformed."
	end
	if #value.objects > value.maxObjects then
		return false, "Parcel exceeds its object limit."
	end
	return true, nil
end

function PropertyPolicy.TryClaim(parcel: unknown, userId: unknown): (any?, string?)
	local valid, validationError = PropertyPolicy.Validate(parcel)
	if not valid then
		return nil, validationError
	end
	if not isPositiveInteger(userId) then
		return nil, "Player user ID must be a positive integer."
	end
	local current = parcel :: any
	if current.ownerUserId ~= nil then
		return nil, "Parcel is already claimed."
	end
	local updated = copyParcel(current)
	updated.ownerUserId = userId
	updated.revision += 1
	return updated, nil
end

function PropertyPolicy.TryRelease(parcel: unknown, userId: unknown, expectedRevision: unknown): (any?, string?)
	local valid, validationError = PropertyPolicy.Validate(parcel)
	if not valid then
		return nil, validationError
	end
	if not isPositiveInteger(userId) then
		return nil, "Player user ID must be a positive integer."
	end
	if not isNonNegativeInteger(expectedRevision) then
		return nil, "Expected parcel revision is invalid."
	end

	local current = parcel :: any
	if current.ownerUserId ~= userId then
		return nil, "Only the parcel owner can release it."
	end
	if current.revision ~= expectedRevision then
		return nil, "Parcel revision conflict."
	end
	if #current.objects > 0 then
		return nil, "A parcel must be cleared before it can be released."
	end

	local updated = copyParcel(current)
	updated.ownerUserId = nil
	updated.revision += 1
	return updated, nil
end

return table.freeze(PropertyPolicy)
