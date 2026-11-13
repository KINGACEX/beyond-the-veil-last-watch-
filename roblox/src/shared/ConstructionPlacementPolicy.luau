--!strict
-- Pure server-side construction placement rules.
-- Coordinates are integer grid cells; the client never supplies dimensions or module metadata.

local ConstructionPlacementPolicy = {}

local function isInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value % 1 == 0
end

local function isNonNegativeInteger(value: unknown): boolean
	return isInteger(value) and (value :: number) >= 0
end

local function isValidId(value: unknown): boolean
	return typeof(value) == "string"
		and #value >= 1
		and #value <= 64
		and string.match(value, "^[%w_%-]+$") ~= nil
end

local function getFootprint(definition: any, rotation: number): (number, number)
	if rotation == 90 or rotation == 270 then
		return definition.FootprintZ, definition.FootprintX
	end
	return definition.FootprintX, definition.FootprintZ
end

local function coversCell(object: any, definition: any, cellX: number, cellZ: number): boolean
	local width, depth = getFootprint(definition, object.rotation)
	return cellX >= object.x
		and cellX < object.x + width
		and cellZ >= object.z
		and cellZ < object.z + depth
end

local function overlaps(left: any, leftDefinition: any, right: any, rightDefinition: any): boolean
	if left.layer ~= right.layer then
		return false
	end
	local leftWidth, leftDepth = getFootprint(leftDefinition, left.rotation)
	local rightWidth, rightDepth = getFootprint(rightDefinition, right.rotation)
	return left.x < right.x + rightWidth
		and left.x + leftWidth > right.x
		and left.z < right.z + rightDepth
		and left.z + leftDepth > right.z
end

local function hasSupport(parcel: any, object: any, definition: any, moduleCatalog: any): boolean
	if definition.SupportLayer == nil then
		return true
	end
	local width, depth = getFootprint(definition, object.rotation)
	for cellX = object.x, object.x + width - 1 do
		for cellZ = object.z, object.z + depth - 1 do
			local supported = false
			for _, supportObject in parcel.objects do
				if supportObject.layer == definition.SupportLayer then
					local supportDefinition = moduleCatalog[supportObject.moduleId]
					if supportDefinition ~= nil and coversCell(supportObject, supportDefinition, cellX, cellZ) then
						supported = true
						break
					end
				end
			end
			if not supported then
				return false
			end
		end
	end
	return true
end

function ConstructionPlacementPolicy.ValidateParcel(parcel: unknown, moduleCatalog: any, propertyPolicy: any): (boolean, string?)
	local parcelValid, parcelError = propertyPolicy.Validate(parcel)
	if not parcelValid then
		return false, parcelError
	end

	local current = parcel :: any
	local seenIds: {[string]: boolean} = {}
	local moduleCounts: {[string]: number} = {}
	local objectCount = 0
	for key, object in current.objects do
		if typeof(key) ~= "number" or key < 1 or key % 1 ~= 0 or typeof(object) ~= "table" then
			return false, "Parcel construction object list is malformed."
		end
		objectCount += 1
	end
	if objectCount ~= #current.objects then
		return false, "Parcel construction object list must be a dense array."
	end

	for index, object in current.objects do
		if typeof(index) ~= "number" or index < 1 or index % 1 ~= 0 or typeof(object) ~= "table" then
			return false, "Parcel contains a malformed construction object."
		end
		if not isValidId(object.id) or seenIds[object.id] then
			return false, "Parcel contains an invalid or duplicate object ID."
		end
		if not isValidId(object.moduleId) then
			return false, "Construction object has an invalid module ID."
		end
		local definition = moduleCatalog[object.moduleId]
		if definition == nil then
			return false, "Parcel contains an unapproved construction module."
		end
		if not isNonNegativeInteger(object.x) or not isNonNegativeInteger(object.z) then
			return false, "Construction object coordinates must be non-negative integers."
		end
		if not isInteger(object.rotation)
			or (object.rotation ~= 0 and object.rotation ~= 90 and object.rotation ~= 180 and object.rotation ~= 270)
		then
			return false, "Construction object rotation is invalid."
		end
		if object.layer ~= definition.Layer or object.layer > current.maxLayer then
			return false, "Construction object is on an unsupported layer."
		end

		local width, depth = getFootprint(definition, object.rotation)
		if object.x + width > current.width or object.z + depth > current.depth then
			return false, "Construction object exceeds the parcel boundary."
		end

		seenIds[object.id] = true
		moduleCounts[object.moduleId] = (moduleCounts[object.moduleId] or 0) + 1
		if moduleCounts[object.moduleId] > definition.MaxPerParcel then
			return false, "Parcel exceeds the limit for this construction module."
		end

		for previousIndex = 1, index - 1 do
			local previous = current.objects[previousIndex]
			local previousDefinition = moduleCatalog[previous.moduleId]
			if previousDefinition ~= nil and overlaps(object, definition, previous, previousDefinition) then
				return false, "Construction objects overlap on the same layer."
			end
		end
	end

	for _, object in current.objects do
		local definition = moduleCatalog[object.moduleId]
		if definition ~= nil and not hasSupport(current, object, definition, moduleCatalog) then
			return false, "Construction object is missing required structural support."
		end
	end

	if #current.objects > current.maxObjects then
		return false, "Parcel exceeds its object budget."
	end
	return true, nil
end

function ConstructionPlacementPolicy.TryPlace(
	parcel: unknown,
	userId: unknown,
	expectedRevision: unknown,
	moduleId: unknown,
	objectId: unknown,
	gridX: unknown,
	gridZ: unknown,
	rotation: unknown,
	moduleCatalog: any,
	propertyPolicy: any
): (any?, string?)
	local valid, validationError = ConstructionPlacementPolicy.ValidateParcel(parcel, moduleCatalog, propertyPolicy)
	if not valid then
		return nil, validationError
	end
	if typeof(userId) ~= "number" or not isInteger(userId) or userId <= 0 then
		return nil, "Player user ID must be a positive integer."
	end
	if not isNonNegativeInteger(expectedRevision) then
		return nil, "Expected parcel revision is invalid."
	end

	local current = parcel :: any
	if current.ownerUserId ~= userId then
		return nil, "Only the parcel owner can place construction modules."
	end
	if current.revision ~= expectedRevision then
		return nil, "Parcel revision conflict."
	end
	if not isValidId(moduleId) or moduleCatalog[moduleId] == nil then
		return nil, "Construction module is not approved."
	end
	if not isValidId(objectId) then
		return nil, "Construction object ID is invalid."
	end
	if not isNonNegativeInteger(gridX) or not isNonNegativeInteger(gridZ) then
		return nil, "Grid coordinates must be non-negative integers."
	end
	if not isInteger(rotation)
		or (rotation ~= 0 and rotation ~= 90 and rotation ~= 180 and rotation ~= 270)
	then
		return nil, "Rotation must be 0, 90, 180 or 270 degrees."
	end
	if #current.objects >= current.maxObjects then
		return nil, "Parcel object budget is exhausted."
	end

	local definition = moduleCatalog[moduleId]
	local object = {
		id = objectId,
		moduleId = moduleId,
		x = gridX,
		z = gridZ,
		layer = definition.Layer,
		rotation = rotation,
	}
	local updated = table.clone(current)
	updated.objects = table.clone(current.objects)
	table.insert(updated.objects, object)
	updated.revision += 1

	local updatedValid, updatedError = ConstructionPlacementPolicy.ValidateParcel(updated, moduleCatalog, propertyPolicy)
	if not updatedValid then
		return nil, updatedError
	end
	return updated, nil
end

function ConstructionPlacementPolicy.TryRemove(
	parcel: unknown,
	userId: unknown,
	expectedRevision: unknown,
	objectId: unknown,
	moduleCatalog: any,
	propertyPolicy: any
): (any?, string?)
	local valid, validationError = ConstructionPlacementPolicy.ValidateParcel(parcel, moduleCatalog, propertyPolicy)
	if not valid then
		return nil, validationError
	end
	if typeof(userId) ~= "number" or not isInteger(userId) or userId <= 0 then
		return nil, "Player user ID must be a positive integer."
	end
	if not isNonNegativeInteger(expectedRevision) then
		return nil, "Expected parcel revision is invalid."
	end
	if not isValidId(objectId) then
		return nil, "Construction object ID is invalid."
	end

	local current = parcel :: any
	if current.ownerUserId ~= userId then
		return nil, "Only the parcel owner can remove construction modules."
	end
	if current.revision ~= expectedRevision then
		return nil, "Parcel revision conflict."
	end

	local updatedObjects = table.clone(current.objects)
	local foundIndex = nil
	for index, object in updatedObjects do
		if object.id == objectId then
			foundIndex = index
			break
		end
	end
	if foundIndex == nil then
		return nil, "Construction object was not found."
	end
	table.remove(updatedObjects, foundIndex)

	local updated = table.clone(current)
	updated.objects = updatedObjects
	updated.revision += 1
	local updatedValid, updatedError = ConstructionPlacementPolicy.ValidateParcel(updated, moduleCatalog, propertyPolicy)
	if not updatedValid then
		return nil, updatedError
	end
	return updated, nil
end

return table.freeze(ConstructionPlacementPolicy)
