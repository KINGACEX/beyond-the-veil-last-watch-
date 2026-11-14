--!strict
-- Server-only, in-memory player session state.
-- Persistence and premium entitlements are intentionally deferred until their schemas are reviewed.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("BTVShared")
local CompanionCatalog = require(shared:WaitForChild("CompanionCatalog"))
local CovenantRankCatalog = require(shared:WaitForChild("CovenantRankCatalog"))
local CompanionOwnershipPolicy = require(script.Parent.CompanionOwnershipPolicy)
local CurrencyAmountPolicy = require(shared:WaitForChild("CurrencyAmountPolicy"))

local PlayerStateService = {}

export type PlayerSnapshot = {
	characterId: string,
	covenantRank: string,
	covenantBranch: string,
	emberCommand: string,
	equippedCompanion: string,
	ownedCompanions: { [string]: boolean },
	aces: number,
	covenantCredits: number,
}

local sessions: { [number]: PlayerSnapshot } = {}

-- Upper bound for a single session adjustment. Economy values are still unset;
-- this only stops an unbounded single award.
local MAX_SESSION_ADJUSTMENT = 1000000

-- Initial access is limited to core/free companions. Premium candidates have no entitlement path yet.

local DEFAULT_STATE: PlayerSnapshot = {
	characterId = "covenant_operative",
	covenantRank = CovenantRankCatalog.Ranks[1],
	covenantBranch = "Unassigned",
	emberCommand = "Regroup",
	equippedCompanion = "ember",
	ownedCompanions = {},
	aces = 0,
	covenantCredits = 0,
}

function PlayerStateService.AddPlayer(player: Player)
	local state = table.clone(DEFAULT_STATE)
	state.ownedCompanions = CompanionOwnershipPolicy.CreateDefaultOwnership()
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
	local canCommand, reason = CompanionOwnershipPolicy.CanUseEmberCommands(state.equippedCompanion)
	if not canCommand then
		return false, reason
	end
	state.emberCommand = command
	return true, nil
end

function PlayerStateService.SetEquippedCompanion(player: Player, companionId: unknown): (boolean, string?)
	local state = sessions[player.UserId]
	if state == nil then
		return false, "Session is not ready."
	end
	local canEquip, reason = CompanionOwnershipPolicy.CanEquip(companionId, state.ownedCompanions, CompanionCatalog)
	if not canEquip then
		return false, reason
	end

	state.equippedCompanion = companionId :: string
	return true, nil
end

function PlayerStateService.AdjustCurrency(player: Player, currency: string, amount: number): (boolean, string?)
	local state = sessions[player.UserId]
	if state == nil then
		return false, "Session is not ready."
	end
	-- Validate here as well as at the currency boundary: this is the function that
	-- actually mutates a balance, so it must not trust its caller.
	local amountVerdict = CurrencyAmountPolicy.IsValidAmount(amount, MAX_SESSION_ADJUSTMENT)
	if not amountVerdict.ok then
		return false, amountVerdict.reason
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
