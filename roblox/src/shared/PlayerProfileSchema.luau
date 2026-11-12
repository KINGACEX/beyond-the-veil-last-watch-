--!strict
-- Pure, side-effect-free player profile schema rules.
-- This module deliberately does not access DataStoreService or enable persistence.

local PlayerProfileSchema = {}

local CURRENT_SCHEMA_VERSION = 1
local DEFAULT_OWNERSHIP: {[string]: boolean} = table.freeze({
	ember = true,
	fox = true,
	owl = true,
	horse = true,
})

local function isNonEmptyString(value: unknown): boolean
	return typeof(value) == "string" and value ~= ""
end

local function isNonNegativeInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value >= 0
		and value % 1 == 0
end

local function validateStringArray(value: unknown): boolean
	if typeof(value) ~= "table" then
		return false
	end

	local count = 0
	for key, item in value do
		if typeof(key) ~= "number" or key < 1 or key % 1 ~= 0 or not isNonEmptyString(item) then
			return false
		end
		count += 1
	end

	return count == #value
end

function PlayerProfileSchema.CreateDefault()
	return {
		schemaVersion = CURRENT_SCHEMA_VERSION,
		revision = 0,
		identity = {
			characterId = "roblox_player_chosen",
			covenantBranch = "Unassigned",
		},
		progression = {
			covenantRank = "Recruit",
			completedEvaluations = {},
			completedMissionIds = {},
		},
		economy = {
			aces = 0,
			covenantCredits = 0,
		},
		companions = {
			owned = table.clone(DEFAULT_OWNERSHIP),
			equipped = "ember",
		},
	}
end

function PlayerProfileSchema.Validate(profile: unknown, rankCatalog: any, companionCatalog: any): (boolean, string?)
	if typeof(profile) ~= "table" then
		return false, "Profile must be a table."
	end
	if profile.schemaVersion ~= CURRENT_SCHEMA_VERSION then
		return false, "Unsupported profile schema version."
	end
	if not isNonNegativeInteger(profile.revision) then
		return false, "Profile revision must be a non-negative integer."
	end

	local identity = profile.identity
	if typeof(identity) ~= "table"
		or not isNonEmptyString(identity.characterId)
		or not isNonEmptyString(identity.covenantBranch)
	then
		return false, "Profile identity is malformed."
	end

	local progression = profile.progression
	if typeof(progression) ~= "table" then
		return false, "Profile progression is malformed."
	end
	if rankCatalog.GetRankIndex(progression.covenantRank) == nil then
		return false, "Profile contains an unknown Covenant rank."
	end
	if not validateStringArray(progression.completedEvaluations)
		or not validateStringArray(progression.completedMissionIds)
	then
		return false, "Profile progression event lists are malformed."
	end

	local economy = profile.economy
	if typeof(economy) ~= "table"
		or not isNonNegativeInteger(economy.aces)
		or not isNonNegativeInteger(economy.covenantCredits)
	then
		return false, "Profile currency balances are malformed."
	end

	local companions = profile.companions
	if typeof(companions) ~= "table" or typeof(companions.owned) ~= "table" then
		return false, "Profile companion ownership is malformed."
	end

	local definitionsById: {[string]: any} = {}
	for _, definition in companionCatalog do
		definitionsById[definition.Id] = definition
	end

	for companionId, isOwned in companions.owned do
		local definition = definitionsById[companionId]
		if definition == nil or typeof(isOwned) ~= "boolean" then
			return false, "Profile contains an invalid companion ownership entry."
		end
		if isOwned and definition.Access == "PremiumCandidate" then
			return false, "Profile cannot grant an unconfigured premium companion."
		end
	end

	local equippedDefinition = definitionsById[companions.equipped]
	if equippedDefinition == nil or companions.owned[companions.equipped] ~= true then
		return false, "Equipped companion must be present in the ownership map."
	end
	if equippedDefinition.Access == "PremiumCandidate" then
		return false, "An unconfigured premium companion cannot be equipped."
	end

	return true, nil
end

return table.freeze(PlayerProfileSchema)
