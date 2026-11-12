--!strict
-- Server-authoritative opening-slice state. This is a small vertical-slice scaffold,
-- not a complete mission, reward system, or authored Scout Report.

local MissionService = {}

export type MissionSnapshot = {
	phase: string,
	sequenceIndex: number,
	objective: string,
	status: string,
}

type PlayerIdentity = {
	UserId: number,
}

type MissionState = {
	phase: string,
	sequenceIndex: number,
}

local states: { [number]: MissionState } = {}

local OBJECTIVES: { [string]: string } = {
	communion_context = "Enter the sanctuary",
	covenant_alert = "Review the Scout Report",
	report_accessed = "Travel to Ridgeview",
	ridgeview_arrival = "Arrive at Ridgeview",
}

local STATUS_TEXT: { [string]: string } = {
	communion_context = "First Sunday • Communion context",
	covenant_alert = "Covenant alert received",
	report_accessed = "Scout Report opened; authored evidence pending. Follow the marked departure point to Ridgeview.",
	ridgeview_arrival = "Ridgeview landscape study reached; investigation content pending.",
}

local SEQUENCE_INDEX: { [string]: number } = {
	communion_context = 1,
	covenant_alert = 2,
	report_accessed = 3,
	ridgeview_arrival = 4,
}

function MissionService.AddPlayer(player: PlayerIdentity)
	states[player.UserId] = {
		phase = "communion_context",
		sequenceIndex = 1,
	}
end

function MissionService.RemovePlayer(player: PlayerIdentity)
	states[player.UserId] = nil
end

function MissionService.GetSnapshot(player: PlayerIdentity): MissionSnapshot?
	local state = states[player.UserId]
	if state == nil then
		return nil
	end
	return {
		phase = state.phase,
		sequenceIndex = state.sequenceIndex,
		objective = OBJECTIVES[state.phase],
		status = STATUS_TEXT[state.phase],
	}
end

function MissionService.Advance(player: PlayerIdentity, expectedPhase: string, nextPhase: string): (boolean, MissionSnapshot?)
	local state = states[player.UserId]
	if state == nil or state.phase ~= expectedPhase then
		return false, nil
	end
	local nextIndex = SEQUENCE_INDEX[nextPhase]
	if nextIndex == nil or nextIndex ~= state.sequenceIndex + 1 then
		return false, nil
	end
	state.phase = nextPhase
	state.sequenceIndex = nextIndex
	return true, MissionService.GetSnapshot(player)
end

return MissionService
