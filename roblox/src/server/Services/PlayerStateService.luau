--!strict
-- Server-only, in-memory player session state.
-- Persistence is intentionally deferred until a profile schema is reviewed.

local PlayerStateService = {}

export type PlayerSnapshot = {
	characterId: string,
	covenantRank: string,
	covenantBranch: string,
	emberCommand: string,
	aces: number,
	covenantCredits: number,
}

local sessions: {[number]: PlayerSnapshot} = {}

local DEFAULT_STATE: PlayerSnapshot = {
	characterId = "asher_vance",
	covenantRank = "Agent/Specialist",
	covenantBranch = "Watchers",
	emberCommand = "Regroup",
	aces = 0,
	covenantCredits = 0,
}

function PlayerStateService.AddPlayer(player: Player)
	sessions[player.UserId] = table.clone(DEFAULT_STATE)
end

function PlayerStateService.RemovePlayer(player: Player)
	sessions[player.UserId] = nil
end

function PlayerStateService.GetSnapshot(player: Player): PlayerSnapshot?
	local state = sessions[player.UserId]
	if state == nil then
		return nil
	end

	return table.clone(state)
end

function PlayerStateService.SetEmberCommand(player: Player, command: string): (boolean, string?)
	local state = sessions[player.UserId]
	if state == nil then
		return false, "Session is not ready."
	end

	state.emberCommand = command
	return true, nil
end

function PlayerStateService.AdjustCurrency(
	player: Player,
	currency: string,
	amount: number
): (boolean, string?)
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
