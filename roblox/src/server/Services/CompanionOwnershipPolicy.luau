--!strict
-- Server-side companion access policy.
-- Ownership is session-only and server-created. Premium candidates stay blocked until
-- a separately reviewed, server-verified entitlement system is approved and implemented.

type CompanionDefinition = {
	Id: string,
	Access: "Core" | "Free" | "PremiumCandidate",
}

type CompanionCatalog = { [string]: CompanionDefinition }

local CompanionOwnershipPolicy = {}

local DEFAULT_OWNED_COMPANIONS: { [string]: boolean } = table.freeze({
	ember = true,
	fox = true,
	owl = true,
	horse = true,
})

function CompanionOwnershipPolicy.CreateDefaultOwnership(): { [string]: boolean }
	-- Each player receives an independent map; no player can mutate another session's access.
	return table.clone(DEFAULT_OWNED_COMPANIONS)
end

function CompanionOwnershipPolicy.CanUseEmberCommands(equippedCompanion: unknown): (boolean, string?)
	if equippedCompanion ~= "ember" then
		return false, "Ember must be equipped to use Ember commands."
	end

	return true, nil
end

function CompanionOwnershipPolicy.CanEquip(
	companionId: unknown,
	ownedCompanions: { [string]: boolean },
	catalog: CompanionCatalog
): (boolean, string?)
	if typeof(companionId) ~= "string" then
		return false, "Invalid companion selection."
	end

	local definition: CompanionDefinition? = nil
	for _, candidate in catalog do
		if candidate.Id == companionId then
			definition = candidate
			break
		end
	end

	if definition == nil then
		return false, "Unknown companion."
	end

	-- Fail closed even if a future bug or malformed server-side grant inserts a premium
	-- candidate into the session ownership map. There is no premium entitlement path yet.
	if definition.Access == "PremiumCandidate" then
		return false, "This companion is not currently available."
	end

	if definition.Access ~= "Core" and definition.Access ~= "Free" then
		return false, "Companion access is not configured."
	end

	if ownedCompanions[companionId] ~= true then
		return false, "Companion is not owned by this player."
	end

	return true, nil
end

return table.freeze(CompanionOwnershipPolicy)
