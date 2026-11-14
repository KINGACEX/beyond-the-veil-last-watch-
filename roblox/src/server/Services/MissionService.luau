--!strict
-- Server-authoritative opening and Ridgeview mission state.
-- Rewards are limited to a non-monetary verified field-record outcome; no reward table is invented.

local MissionService = {}

export type MissionSnapshot = {
	phase: string,
	region: string,
	sequenceIndex: number,
	objective: string,
	status: string,
	ridgeviewObjective: string?,
	missionComplete: boolean,
	completionOutcome: string?,
}

type PlayerIdentity = {
	UserId: number,
}

type MissionState = {
	phase: string,
	region: string,
	sequenceIndex: number,
	ridgeviewObjective: string?,
	completedMissionIds: { string },
}

local states: { [number]: MissionState } = {}

local OBJECTIVES: { [string]: string } = {
	communion_context = "Enter the sanctuary",
	covenant_alert = "Review the Scout Report",
	report_accessed = "Travel to Ridgeview",
	ridgeview_arrival = "Arrive at Ridgeview",
	ridgeview_investigation = "Investigate Ridgeview",
	mission_complete = "Ridgeview field report submitted",
}

local STATUS_TEXT: { [string]: string } = {
	communion_context = "First Sunday • Communion context",
	covenant_alert = "Covenant field briefing available. Review the Scout Report at the welcome desk.",
	report_accessed = "Briefing reviewed. Follow the Ridgeview wayfinding sign and use the departure prompt when ready.",
	ridgeview_arrival = "Explore the settlement, inspect the marked approach evidence, and speak with residents when ready.",
	ridgeview_investigation = "Record observations, speak with residents, and keep testimony separate from conclusions.",
	mission_complete = "Your verified observations and any explicitly authorized statements are recorded for this session. No unverified conclusion has been added.",
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
	review_findings = { pike_followup = true },
}

local SEQUENCE_INDEX: { [string]: number } = {
	communion_context = 1,
	covenant_alert = 2,
	report_accessed = 3,
	ridgeview_arrival = 4,
	ridgeview_investigation = 5,
}

function MissionService.AddPlayer(player: PlayerIdentity, completedMissionIds: { string }?, persistedProgress: any?)
	local restoredIds: { string } = {}
	local ridgeviewCompleted = false
	if typeof(completedMissionIds) == "table" then
		for _, missionId in completedMissionIds do
			if typeof(missionId) == "string" and missionId ~= "" then
				table.insert(restoredIds, missionId)
				if missionId == "ridgeview_investigation_001" then
					ridgeviewCompleted = true
				end
			end
		end
	end
	local restoredPhase = if ridgeviewCompleted then "mission_complete" else "communion_context"
	local restoredIndex = if ridgeviewCompleted then 6 else 1
	local restoredObjective = if ridgeviewCompleted then "review_findings" else nil
	if not ridgeviewCompleted and typeof(persistedProgress) == "table" then
		local phase = persistedProgress.phase
		local sequenceIndex = persistedProgress.sequenceIndex
		local objective = persistedProgress.ridgeviewObjective
		if
			typeof(phase) == "string"
			and SEQUENCE_INDEX[phase] ~= nil
			and typeof(sequenceIndex) == "number"
			and sequenceIndex == SEQUENCE_INDEX[phase]
			and (
				(phase == "ridgeview_investigation" and typeof(objective) == "string" and RIDGEVIEW_OBJECTIVES[objective] ~= nil)
				or (phase ~= "ridgeview_investigation" and objective == nil)
			)
		then
			restoredPhase = phase
			restoredIndex = sequenceIndex
			restoredObjective = objective
		end
	end
	local restoredRegion = if restoredPhase == "ridgeview_arrival"
			or restoredPhase == "ridgeview_investigation"
			or restoredPhase == "mission_complete"
		then "ridgeview"
		else "temple"
	if typeof(persistedProgress) == "table" and (persistedProgress.region == "temple" or persistedProgress.region == "ridgeview") then
		local requestedRegion = persistedProgress.region
		local phaseAllowsRidgeview = restoredPhase == "ridgeview_arrival" or restoredPhase == "ridgeview_investigation" or restoredPhase == "mission_complete"
		if requestedRegion == "temple" or phaseAllowsRidgeview then
			restoredRegion = requestedRegion
		end
	end
	states[player.UserId] = {
		phase = restoredPhase,
		region = restoredRegion,
		sequenceIndex = restoredIndex,
		ridgeviewObjective = restoredObjective,
		completedMissionIds = restoredIds,
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
		region = state.region,
		sequenceIndex = state.sequenceIndex,
		objective = objective,
		status = status,
		ridgeviewObjective = if state.phase == "ridgeview_investigation" then state.ridgeviewObjective else nil,
		missionComplete = state.phase == "mission_complete",
		completionOutcome = if state.phase == "mission_complete" then "Non-monetary outcome: a verified field record has been submitted." else nil,
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
	if nextPhase == "ridgeview_arrival" then
		state.region = "ridgeview"
	end
	if nextPhase == "ridgeview_investigation" then
		state.ridgeviewObjective = "collect_observations"
	end
	return true, MissionService.GetSnapshot(player)
end

function MissionService.AdvanceRidgeviewObjective(player: PlayerIdentity, expectedObjective: string, nextObjective: string): (boolean, MissionSnapshot?)
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

function MissionService.CompleteRidgeviewInvestigation(player: PlayerIdentity): (boolean, MissionSnapshot?)
	local state = states[player.UserId]
	if state == nil or state.phase ~= "ridgeview_investigation" or state.ridgeviewObjective ~= "review_findings" then
		return false, nil
	end
	for _, missionId in state.completedMissionIds do
		if missionId == "ridgeview_investigation_001" then
			return false, nil
		end
	end
	table.insert(state.completedMissionIds, "ridgeview_investigation_001")
	state.phase = "mission_complete"
	state.sequenceIndex = 6
	return true, MissionService.GetSnapshot(player)
end

function MissionService.GetCompletedMissionIds(player: PlayerIdentity): { string }
	local state = states[player.UserId]
	return if state ~= nil then table.clone(state.completedMissionIds) else {}
end

function MissionService.GetRidgeviewObjective(player: PlayerIdentity): string?
	local state = states[player.UserId]
	return if state ~= nil then state.ridgeviewObjective else nil
end

function MissionService.GetRegion(player: PlayerIdentity): string?
	local state = states[player.UserId]
	return if state ~= nil then state.region else nil
end

function MissionService.SetRegion(player: PlayerIdentity, region: unknown): boolean
	local state = states[player.UserId]
	if state == nil or (region ~= "temple" and region ~= "ridgeview") then
		return false
	end
	local phaseAllowsRidgeview = state.phase == "ridgeview_arrival" or state.phase == "ridgeview_investigation" or state.phase == "mission_complete"
	if region == "ridgeview" and not phaseAllowsRidgeview then
		return false
	end
	state.region = region
	return true
end

function MissionService.GetPersistentProgress(player: PlayerIdentity)
	local state = states[player.UserId]
	if state == nil then
		return nil
	end
	return {
		phase = state.phase,
		region = state.region,
		sequenceIndex = state.sequenceIndex,
		ridgeviewObjective = if state.phase == "ridgeview_investigation" then state.ridgeviewObjective else nil,
	}
end

return MissionService
