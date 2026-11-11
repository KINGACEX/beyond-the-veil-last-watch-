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

type MissionState = {
	phase: string,
	sequenceIndex: number,
}

local states: {[number]: MissionState} = {}

local OBJECTIVES: {[string]: string} = {
	communion_context = "Enter the sanctuary",
	covenant_alert = "Review the Scout Report",
	report_accessed = "Scout Report opened — authored evidence pending",
}

local STATUS_TEXT: {[string]: string} = {
	communion_context = "First Sunday • Communion context",
	covenant_alert = "Covenant alert received",
	report_accessed = "Report interface ready; authored evidence pending.",
}

local SEQUENCE_INDEX: {[string]: number} = {
	communion_context = 1,
	covenant_alert = 2,
	report_accessed = 3,
}

function MissionService.AddPlayer(player: Player)
	states[player.UserId] = {
		phase = "communion_context",
		sequenceIndex = 1,
	}
end

function MissionService.RemovePlayer(player: Player)
	states[player.UserId] = nil
end

function MissionService.GetSnapshot(player: Player): MissionSnapshot?
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

function MissionService.Advance(player: Player, expectedPhase: string, nextPhase: string): (boolean, MissionSnapshot?)
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
