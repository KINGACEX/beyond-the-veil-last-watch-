--!strict
-- Server-only, in-memory player session state.
-- Persistence and premium entitlements are intentionally deferred until their schemas are reviewed.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CompanionCatalog = require(ReplicatedStorage:WaitForChild("BTVShared"):WaitForChild("CompanionCatalog"))

local PlayerStateService = {}

export type PlayerSnapshot = {
	characterId: string,
	covenantRank: string,
	covenantBranch: string,
	emberCommand: string,
	equippedCompanion: string,
	ownedCompanions: {[string]: boolean},
	aces: number,
	covenantCredits: number,
}

local sessions: {[number]: PlayerSnapshot} = {}

-- Initial access is limited to core/free companions. Premium candidates have no entitlement path yet.
local DEFAULT_OWNED_COMPANIONS: {[string]: boolean} = {
	ember = true,
	fox = true,
	owl = true,
	horse = true,
}

local DEFAULT_STATE: PlayerSnapshot = {
	characterId = "asher_vance",
	covenantRank = "Agent/Specialist",
	covenantBranch = "Watchers",
	emberCommand = "Regroup",
	equippedCompanion = "ember",
	ownedCompanions = {},
	aces = 0,
	covenantCredits = 0,
}

function PlayerStateService.AddPlayer(player: Player)
	local state = table.clone(DEFAULT_STATE)
	state.ownedCompanions = table.clone(DEFAULT_OWNED_COMPANIONS)
	sessions[player.UserId] = state
end

function PlayerStateService.RemovePlayer(player: Player)
	sessions[player.UserId] = nil
end

function PlayerStateService.GetSnapshot(player: Player): PlayerSnapshot?
	local state = sessions[player.UserId]
	if state == nil then
		return nil
	end
	local snapshot = table.clone(state)
	snapshot.ownedCompanions = table.clone(state.ownedCompanions)
	return snapshot
end

function PlayerStateService.SetEmberCommand(player: Player, command: string): (boolean, string?)
	local state = sessions[player.UserId]
	if state == nil then
		return false, "Session is not ready."
	end
	state.emberCommand = command
	return true, nil
end

function PlayerStateService.SetEquippedCompanion(player: Player, companionId: unknown): (boolean, string?)
	local state = sessions[player.UserId]
	if state == nil then
		return false, "Session is not ready."
	end
	if typeof(companionId) ~= "string" then
		return false, "Invalid companion selection."
	end

	local isCatalogued = false
	for _, definition in CompanionCatalog do
		if definition.Id == companionId then
			isCatalogued = true
			break
		end
	end
	if not isCatalogued then
		return false, "Unknown companion."
	end
	if state.ownedCompanions[companionId] ~= true then
		return false, "Companion is not owned by this player."
	end

	state.equippedCompanion = companionId
	return true, nil
end

function PlayerStateService.AdjustCurrency(player: Player, currency: string, amount: number): (boolean, string?)
	local state = sessions[player.UserId]
	if state == nil then
		return false, "Session is not ready."
	end
	if currency == "Aces" then
		state.aces += amount
	elseif currency == "Covenant Credits" then
		state.covenantCredits += amount
	else
		return false, "Unknown currency."
	end
	return true, nil
end

return PlayerStateService
