--!strict
-- Ridgeview investigation regression tests: journal integration, consent scope and mission branching.

local Policy = require("../src/shared/RidgeviewInvestigationPolicy")
local Catalog = require("../src/shared/RidgeviewFieldNoteCatalog")
local MissionService = require("../src/server/Services/MissionService")

local function expect(condition: boolean, message: string)
	if not condition then
		error("[Ridgeview investigation test failed] " .. message)
	end
end

do
	local firstPlayer = Policy.NewState()
	local secondPlayer = Policy.NewState()
	expect(not Policy.CanSubmitFindings(firstPlayer), "an empty investigation cannot be submitted")

	local invalidType, invalidTypeError = Policy.TryRecordObservation(firstPlayer, 42, Catalog)
	expect(invalidType == nil and invalidTypeError ~= nil, "observation IDs must be strings")

	local unknown, unknownError = Policy.TryRecordObservation(firstPlayer, "invented_clue", Catalog)
	expect(unknown == nil and unknownError ~= nil, "unknown observations are rejected")

	local firstRecorded, firstError = Policy.TryRecordObservation(firstPlayer, "approach_belongings", Catalog)
	expect(firstRecorded ~= nil and firstError == nil, "approved observation can be recorded")
	assert(firstRecorded ~= nil, "first journal state exists")
	expect(firstPlayer.observations.approach_belongings == nil, "observation recording does not mutate the source state")

	local duplicate, duplicateError = Policy.TryRecordObservation(firstRecorded, "approach_belongings", Catalog)
	expect(duplicate == nil and duplicateError ~= nil, "duplicate observation is rejected")

	local secondRecorded, secondError = Policy.TryRecordObservation(firstRecorded, "parked_work_vehicle", Catalog)
	expect(secondRecorded ~= nil and secondError == nil, "second approved observation can be recorded")
	assert(secondRecorded ~= nil, "second journal state exists")
	expect(secondPlayer.observations.approach_belongings == nil, "another player's journal remains isolated")

	local prematurePermission, prematurePermissionError = Policy.SetWrenSharePermission(firstPlayer, true)
	expect(prematurePermission == nil and prematurePermissionError ~= nil, "permission cannot exist before testimony is recorded")

	local withTestimony = Policy.RecordWrenTestimony(secondRecorded)
	expect(withTestimony.wrenTestimonyRecorded, "Wren testimony is recorded separately from observations")
	expect(not withTestimony.wrenSharePermission, "recording testimony does not imply sharing permission")
	expect(not withTestimony.pikeAdmissionRecorded, "Pike admission cannot pre-exist testimony disclosure")
	expect(not Policy.CanSubmitFindings(withTestimony), "findings cannot be submitted before Wren's explicit privacy decision")

	local malformedPermission, malformedPermissionError = Policy.SetWrenSharePermission(withTestimony, "yes")
	expect(malformedPermission == nil and malformedPermissionError ~= nil, "permission requires an explicit boolean")

	local privatePermission, privatePermissionError = Policy.SetWrenSharePermission(withTestimony, false)
	expect(privatePermission ~= nil and privatePermissionError == nil, "Wren can keep testimony private")
	assert(privatePermission ~= nil, "private permission state exists")
	expect(privatePermission.wrenDisclosureDecisionMade, "a private response records that Wren explicitly declined sharing")
	expect(Policy.CanSubmitFindings(privatePermission), "the private testimony route can submit after both observations and Wren's explicit decision")
	expect(not Policy.CanDiscussWrenWithPike(privatePermission), "private testimony cannot be discussed with Pike")
	expect(Policy.CanSubmitFindings(privatePermission), "the private testimony route can submit after both observations and testimony are recorded")
	local blockedAdmission, blockedAdmissionError = Policy.RecordPikeAdmission(privatePermission)
	expect(blockedAdmission == nil and blockedAdmissionError ~= nil, "Pike admission is blocked without permission")

	local authorized, authorizationError = Policy.SetWrenSharePermission(withTestimony, true)
	expect(authorized ~= nil and authorizationError == nil, "explicit permission can be granted after testimony")
	assert(authorized ~= nil, "authorized state exists")
	expect(authorized.wrenDisclosureDecisionMade, "explicit permission records a completed disclosure decision")
	expect(not Policy.CanSubmitFindings(authorized), "authorized path must complete Pike's follow-up before submission")
	expect(Policy.CanDiscussWrenWithPike(authorized), "authorized detail can be discussed with Pike")
	expect(not Policy.CanSubmitFindings(authorized), "the consented route requires Pike's follow-up before submission")

	local authorizedEntries = Policy.Snapshot(authorized, Catalog)
	local disclosureEntry = nil
	local privateEntry = nil
	for _, entry in authorizedEntries do
		if entry.Id == "wren_authorized_disclosure" then
			disclosureEntry = entry
		elseif entry.Id == "wren_testimony_private" then
			privateEntry = entry
		end
	end
	expect(disclosureEntry ~= nil, "journal records the authorized disclosure")
	expect(privateEntry ~= nil, "journal retains the private source testimony for its owner")
	assert(disclosureEntry ~= nil, "authorized disclosure exists")
	expect(string.find(disclosureEntry.Text, "only this detail", 1, true) ~= nil, "disclosure explicitly records the narrow permission scope")
	expect(string.find(disclosureEntry.Text, "does not know what happened", 1, true) == nil, "private details are not copied into the disclosure entry")

	local admission, admissionError = Policy.RecordPikeAdmission(authorized)
	expect(admission ~= nil and admissionError == nil, "Pike admission is recordable after authorized discussion")
	assert(admission ~= nil, "Pike admission state exists")
	expect(admission.pikeAdmissionRecorded, "Pike admission flag is set")
	expect(Policy.CanSubmitFindings(admission), "consented path is ready after Pike's limited admission")
	expect(Policy.CanSubmitFindings(admission), "the consented route can submit after Pike's limited admission")
	local completeEntries = Policy.Snapshot(admission, Catalog)
	expect(#completeEntries == 5, "journal combines two observations, testimony, permission and Pike's admission")

	local retold = Policy.RecordWrenTestimony(admission)
	expect(not retold.wrenSharePermission, "a newly recorded testimony never inherits previous permission")
	expect(not retold.pikeAdmissionRecorded, "a newly recorded testimony resets dependent Pike admission")
	expect(not retold.wrenDisclosureDecisionMade, "a newly recorded testimony requires a fresh explicit disclosure decision")
	expect(not Policy.CanSubmitFindings(retold), "a newly recorded account cannot be submitted without a fresh disclosure decision")
	expect(not Policy.CanSubmitFindings(retold), "re-recording testimony requires the disclosure decision to be completed again")
	local retoldAdmission, retoldError = Policy.RecordPikeAdmission(retold)
	expect(retoldAdmission == nil and retoldError ~= nil, "Pike admission is blocked after permission reset")

	local pendingDecision = Policy.RecordWrenTestimony(secondRecorded)
	local restoredPendingDecision, pendingDecisionError = Policy.RestoreState(Policy.CloneState(pendingDecision), Catalog)
	expect(restoredPendingDecision ~= nil and pendingDecisionError == nil, "in-progress testimony state can be restored")
	expect(
		restoredPendingDecision ~= nil and not restoredPendingDecision.wrenDisclosureDecisionMade,
		"restoration does not mistake default-private permission for an explicit privacy decision"
	)
	expect(
		restoredPendingDecision ~= nil and not Policy.CanSubmitFindings(restoredPendingDecision),
		"restored testimony still requires Wren's explicit disclosure decision"
	)

	local persistedState = Policy.CloneState(admission)
	local restoredState, restoreError = Policy.RestoreState(persistedState, Catalog)
	expect(restoredState ~= nil and restoreError == nil, "valid completed investigation state can be restored")
	assert(restoredState ~= nil, "restored investigation state exists")
	expect(
		restoredState.wrenSharePermission and restoredState.wrenDisclosureDecisionMade and restoredState.pikeAdmissionRecorded,
		"restoration preserves the explicit consent chain"
	)
	expect(#Policy.Snapshot(restoredState, Catalog) == 5, "restored investigation retains its complete journal")

	local malformedPersistedState = Policy.CloneState(admission)
	malformedPersistedState.wrenSharePermission = false
	local rejectedPersistedState, rejectedPersistedError = Policy.RestoreState(malformedPersistedState, Catalog)
	expect(rejectedPersistedState == nil and rejectedPersistedError ~= nil, "restoration rejects Pike admission without Wren permission")

	local secondPlayerEntries = Policy.Snapshot(secondPlayer, Catalog)
	expect(#secondPlayerEntries == 0, "another player's journal contains no observations or testimony")
	print("[BTV tests] Ridgeview unified journal and narrow consent policy passed.")
end

do
	local player = { UserId = 991701 }
	local otherPlayer = { UserId = 991702 }
	MissionService.AddPlayer(player)
	MissionService.AddPlayer(otherPlayer)

	local phases = {
		{ "communion_context", "covenant_alert" },
		{ "covenant_alert", "report_accessed" },
		{ "report_accessed", "ridgeview_arrival" },
		{ "ridgeview_arrival", "ridgeview_investigation" },
	}
	for _, pair in phases do
		local advanced = MissionService.Advance(player, pair[1], pair[2])
		expect(advanced, "opening mission reaches Ridgeview through sequential phases")
	end

	local initial = MissionService.GetSnapshot(player)
	expect(initial ~= nil and initial.ridgeviewObjective == "collect_observations", "Ridgeview starts by collecting observations")
	local skipped = MissionService.AdvanceRidgeviewObjective(player, "collect_observations", "pike_followup")
	expect(not skipped, "investigation objectives cannot be skipped")
	local otherSnapshot = MissionService.GetSnapshot(otherPlayer)
	expect(otherSnapshot ~= nil and otherSnapshot.phase == "communion_context", "one player's mission progression does not affect another")

	local restoredPlayer = { UserId = 991704 }
	MissionService.AddPlayer(restoredPlayer, { "ridgeview_investigation_001" })
	local restoredMission = MissionService.GetSnapshot(restoredPlayer)
	expect(restoredMission ~= nil and restoredMission.phase == "mission_complete", "completed mission IDs restore the completed Ridgeview state")
	expect(#MissionService.GetCompletedMissionIds(restoredPlayer) == 1, "restored completion remains available for profile saving")

	local observationsDone = MissionService.AdvanceRidgeviewObjective(player, "collect_observations", "speak_with_wren")
	expect(observationsDone, "completed observations unlock Wren conversation")
	local testimonyDone = MissionService.AdvanceRidgeviewObjective(player, "speak_with_wren", "choose_disclosure")
	expect(testimonyDone, "Wren testimony unlocks the explicit disclosure decision")
	local consentedPath = MissionService.AdvanceRidgeviewObjective(player, "choose_disclosure", "pike_followup")
	expect(consentedPath, "authorized disclosure unlocks Pike follow-up")
	local earlyCompletion = MissionService.CompleteRidgeviewInvestigation(player)
	expect(not earlyCompletion, "Ridgeview cannot complete before the review objective")
	local review = MissionService.AdvanceRidgeviewObjective(player, "pike_followup", "review_findings")
	expect(review, "Pike's limited admission advances to review")
	local completed, completionSnapshot = MissionService.CompleteRidgeviewInvestigation(player)
	expect(completed and completionSnapshot ~= nil, "Ridgeview can be completed after the review objective")
	assert(completionSnapshot ~= nil, "completion snapshot exists")
	expect(completionSnapshot.phase == "mission_complete" and completionSnapshot.missionComplete, "completion is reflected in the authoritative snapshot")
	expect(completionSnapshot.sequenceIndex == 6, "completion advances the opening sequence to its final step")
	expect(completionSnapshot.completionOutcome ~= nil, "completion reports its non-monetary outcome")
	local completedIds = MissionService.GetCompletedMissionIds(player)
	expect(#completedIds == 1 and completedIds[1] == "ridgeview_investigation_001", "completion records a stable mission ID for later persistence")
	table.clear(completedIds)
	expect(#MissionService.GetCompletedMissionIds(player) == 1, "completed mission IDs are returned as a defensive copy")
	local duplicateCompletion = MissionService.CompleteRidgeviewInvestigation(player)
	expect(not duplicateCompletion, "completed mission cannot be submitted twice")

	local privatePlayer = { UserId = 991703 }
	MissionService.AddPlayer(privatePlayer)
	for _, pair in phases do
		MissionService.Advance(privatePlayer, pair[1], pair[2])
	end
	MissionService.AdvanceRidgeviewObjective(privatePlayer, "collect_observations", "speak_with_wren")
	MissionService.AdvanceRidgeviewObjective(privatePlayer, "speak_with_wren", "choose_disclosure")
	local privatePath = MissionService.AdvanceRidgeviewObjective(privatePlayer, "choose_disclosure", "review_findings")
	expect(privatePath, "keeping Wren's testimony private still allows investigation review")
	local privateCompletion, privateCompletionSnapshot = MissionService.CompleteRidgeviewInvestigation(privatePlayer)
	expect(privateCompletion and privateCompletionSnapshot ~= nil, "the private-testimony route can also complete Ridgeview")
	expect(#MissionService.GetCompletedMissionIds(otherPlayer) == 0, "mission completion remains isolated from other players")
	print("[BTV tests] Ridgeview branching mission progression passed.")
end
