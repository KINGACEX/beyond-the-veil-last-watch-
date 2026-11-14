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
	ridgeviewObjective: string?,
}

local states: { [number]: MissionState } = {}

local OBJECTIVES: { [string]: string } = {
	communion_context = "Enter the sanctuary",
	covenant_alert = "Review the Scout Report",
	report_accessed = "Scout Report opened — authored evidence pending",
	ridgeview_arrival = "Arrive at Ridgeview",
	ridgeview_investigation = "Investigate Ridgeview",
}

local STATUS_TEXT: { [string]: string } = {
	communion_context = "First Sunday • Communion context",
	covenant_alert = "Covenant alert received",
	report_accessed = "Scout Report available. Follow the Ridgeview travel marker.",
	ridgeview_arrival = "Ridgeview reached. Explore the outpost and record one verifiable observation.",
	ridgeview_investigation = "First observation recorded. Continue exploring and preserve only what you can verify.",
}

local RIDGEVIEW_OBJECTIVES: { [string]: { objective: string, status: string } } = {
	collect_observations = {
		objective = "Record the remaining verifiable Ridgeview observation",
		status = "Compare the belongings and work vehicle without assuming who owns them or why they were left.",
	},
	speak_with_wren = {
		objective = "Speak with Wren and establish what she personally observed",
		status = "Listen carefully. Keep her direct observations separate from what she does not know.",
	},
	choose_disclosure = {
		objective = "Respect Wren's decision about sharing her account",
		status = "Her testimony is private unless she explicitly authorizes a specific detail to be shared.",
	},
	pike_followup = {
		objective = "Ask Dorian Pike about the camp using only Wren's authorized detail",
		status = "Share only the one detail Wren approved. Do not disclose the rest of her account.",
	},
	review_findings = {
		objective = "Review the evidence, testimony, and unresolved questions",
		status = "Separate observations, testimony, Pike's statement, and conclusions that remain unproven.",
	},
}

local RIDGEVIEW_TRANSITIONS: { [string]: { [string]: boolean } } = {
	collect_observations = { speak_with_wren = true },
	speak_with_wren = { choose_disclosure = true },
	choose_disclosure = { pike_followup = true, review_findings = true },
	pike_followup = { review_findings = true },
}

local SEQUENCE_INDEX: { [string]: number } = {
	communion_context = 1,
	covenant_alert = 2,
	report_accessed = 3,
	ridgeview_arrival = 4,
	ridgeview_investigation = 5,
}

function MissionService.AddPlayer(player: PlayerIdentity)
	states[player.UserId] = {
		phase = "communion_context",
		sequenceIndex = 1,
		ridgeviewObjective = nil,
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
	local objective = OBJECTIVES[state.phase]
	local status = STATUS_TEXT[state.phase]
	if state.phase == "ridgeview_investigation" and state.ridgeviewObjective ~= nil then
		local ridgeview = RIDGEVIEW_OBJECTIVES[state.ridgeviewObjective]
		if ridgeview ~= nil then
			objective = ridgeview.objective
			status = ridgeview.status
		end
	end
	return {
		phase = state.phase,
		sequenceIndex = state.sequenceIndex,
		objective = objective,
		status = status,
		ridgeviewObjective = state.ridgeviewObjective,
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
	if nextPhase == "ridgeview_investigation" then
		state.ridgeviewObjective = "collect_observations"
	end
	return true, MissionService.GetSnapshot(player)
end

function MissionService.AdvanceRidgeviewObjective(
	player: PlayerIdentity,
	expectedObjective: string,
	nextObjective: string
): (boolean, MissionSnapshot?)
	local state = states[player.UserId]
	if state == nil or state.phase ~= "ridgeview_investigation" then
		return false, nil
	end
	if state.ridgeviewObjective ~= expectedObjective then
		return false, nil
	end
	local allowed = RIDGEVIEW_TRANSITIONS[expectedObjective]
	if allowed == nil or allowed[nextObjective] ~= true then
		return false, nil
	end
	state.ridgeviewObjective = nextObjective
	return true, MissionService.GetSnapshot(player)
end

function MissionService.GetRidgeviewObjective(player: PlayerIdentity): string?
	local state = states[player.UserId]
	return if state ~= nil then state.ridgeviewObjective else nil
end

return MissionService
