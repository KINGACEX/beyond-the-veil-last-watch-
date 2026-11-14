--!strict
-- Shared server singleton for per-player Ridgeview investigation state.
-- Session-only by design; never broadcasts one player's journal to other players.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("BTVShared")
local Policy = require(shared:WaitForChild("RidgeviewInvestigationPolicy"))
local Catalog = require(shared:WaitForChild("RidgeviewFieldNoteCatalog"))

local RidgeviewInvestigationService = {}
local states: { [number]: Policy.State } = {}

type PlayerIdentity = { UserId: number }

local function getState(player: PlayerIdentity): Policy.State
	local state = states[player.UserId]
	if state == nil then
		state = Policy.NewState()
		states[player.UserId] = state
	end
	return state
end

function RidgeviewInvestigationService.GetState(player: PlayerIdentity): Policy.State
	return getState(player)
end

function RidgeviewInvestigationService.TryRecordObservation(player: PlayerIdentity, noteId: unknown): (boolean, string?)
	local updated, reason = Policy.TryRecordObservation(getState(player), noteId, Catalog)
	if updated == nil then
		return false, reason
	end
	states[player.UserId] = updated
	return true, nil
end

function RidgeviewInvestigationService.RecordWrenTestimony(player: PlayerIdentity)
	states[player.UserId] = Policy.RecordWrenTestimony(getState(player))
end

function RidgeviewInvestigationService.SetWrenSharePermission(player: PlayerIdentity, permission: unknown): (boolean, string?)
	local updated, reason = Policy.SetWrenSharePermission(getState(player), permission)
	if updated == nil then
		return false, reason
	end
	states[player.UserId] = updated
	return true, nil
end

function RidgeviewInvestigationService.CanDiscussWrenWithPike(player: PlayerIdentity): boolean
	return Policy.CanDiscussWrenWithPike(getState(player))
end

function RidgeviewInvestigationService.RecordPikeAdmission(player: PlayerIdentity): (boolean, string?)
	local updated, reason = Policy.RecordPikeAdmission(getState(player))
	if updated == nil then
		return false, reason
	end
	states[player.UserId] = updated
	return true, nil
end

function RidgeviewInvestigationService.GetJournalSnapshot(player: PlayerIdentity)
	return Policy.Snapshot(getState(player), Catalog)
end

function RidgeviewInvestigationService.RemovePlayer(player: PlayerIdentity)
	states[player.UserId] = nil
end

return RidgeviewInvestigationService
