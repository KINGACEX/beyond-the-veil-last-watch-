--!strict
-- Pure Ridgeview investigation rules. Evidence, testimony and disclosure remain distinct.
-- No conclusions, rewards, or player-facing truth scores are generated here.

local RidgeviewInvestigationPolicy = {}

export type State = {
	observations: { [string]: boolean },
	wrenTestimonyRecorded: boolean,
	wrenSharePermission: boolean,
	wrenDisclosureDecisionMade: boolean,
	pikeAdmissionRecorded: boolean,
}

export type JournalEntry = {
	Id: string,
	Title: string,
	Text: string,
	Confidence: string,
	Category: string,
	SortOrder: number,
}

function RidgeviewInvestigationPolicy.NewState(): State
	return {
		observations = {},
		wrenTestimonyRecorded = false,
		wrenSharePermission = false,
		wrenDisclosureDecisionMade = false,
		pikeAdmissionRecorded = false,
	}
end

function RidgeviewInvestigationPolicy.TryRecordObservation(current: State, noteId: unknown, catalog: { [string]: any }): (State?, string?)
	if typeof(noteId) ~= "string" then
		return nil, "Invalid field-note identifier."
	end
	if catalog[noteId] == nil then
		return nil, "Unknown field note."
	end
	if current.observations[noteId] == true then
		return nil, "Field note already recorded."
	end

	local updated = table.clone(current)
	updated.observations = table.clone(current.observations)
	updated.observations[noteId] = true
	return updated, nil
end

function RidgeviewInvestigationPolicy.RecordWrenTestimony(current: State): State
	local updated = table.clone(current)
	updated.wrenTestimonyRecorded = true
	-- A newly recorded account never inherits an earlier disclosure permission.
	updated.wrenSharePermission = false
	updated.wrenDisclosureDecisionMade = false
	updated.pikeAdmissionRecorded = false
	return updated
end

function RidgeviewInvestigationPolicy.SetWrenSharePermission(current: State, permission: unknown): (State?, string?)
	if not current.wrenTestimonyRecorded then
		return nil, "Wren testimony must be recorded before permission can be set."
	end
	if typeof(permission) ~= "boolean" then
		return nil, "Sharing permission must be an explicit boolean."
	end
	if permission == false and current.pikeAdmissionRecorded then
		return nil, "A completed conversation cannot be retroactively undisclosed."
	end

	local updated = table.clone(current)
	updated.wrenSharePermission = permission
	updated.wrenDisclosureDecisionMade = true
	return updated, nil
end

function RidgeviewInvestigationPolicy.CanDiscussWrenWithPike(current: State): boolean
	return current.wrenTestimonyRecorded and current.wrenSharePermission
end

function RidgeviewInvestigationPolicy.RecordPikeAdmission(current: State): (State?, string?)
	if not RidgeviewInvestigationPolicy.CanDiscussWrenWithPike(current) then
		return nil, "Pike's response requires recorded testimony and explicit sharing permission."
	end
	local updated = table.clone(current)
	updated.pikeAdmissionRecorded = true
	return updated, nil
end

function RidgeviewInvestigationPolicy.CloneState(current: State): State
	local updated = table.clone(current)
	updated.observations = table.clone(current.observations)
	return updated
end

function RidgeviewInvestigationPolicy.RestoreState(candidate: unknown, catalog: { [string]: any }): (State?, string?)
	if typeof(candidate) ~= "table" then
		return nil, "Persisted Ridgeview investigation state is malformed."
	end
	local source = candidate :: any
	if
		typeof(source.observations) ~= "table"
		or typeof(source.wrenTestimonyRecorded) ~= "boolean"
		or typeof(source.wrenSharePermission) ~= "boolean"
		or (source.wrenDisclosureDecisionMade ~= nil and typeof(source.wrenDisclosureDecisionMade) ~= "boolean")
		or typeof(source.pikeAdmissionRecorded) ~= "boolean"
	then
		return nil, "Persisted Ridgeview investigation fields are malformed."
	end
	local observations: { [string]: boolean } = {}
	for noteId, recorded in source.observations do
		if typeof(noteId) ~= "string" or catalog[noteId] == nil or recorded ~= true then
			return nil, "Persisted Ridgeview observation is unknown or invalid."
		end
		observations[noteId] = true
	end
	if source.wrenSharePermission and not source.wrenTestimonyRecorded then
		return nil, "Persisted Wren permission has no recorded testimony."
	end
	if source.pikeAdmissionRecorded and not source.wrenSharePermission then
		return nil, "Persisted Pike admission has no explicit Wren permission."
	end
	return {
		observations = observations,
		wrenTestimonyRecorded = source.wrenTestimonyRecorded,
		wrenSharePermission = source.wrenSharePermission,
		wrenDisclosureDecisionMade = if typeof(source.wrenDisclosureDecisionMade) == "boolean" then source.wrenDisclosureDecisionMade else source.wrenSharePermission,
		pikeAdmissionRecorded = source.pikeAdmissionRecorded,
	},
		nil
end

function RidgeviewInvestigationPolicy.CanSubmitFindings(state: State): boolean
	local observationsComplete = state.observations.approach_belongings == true and state.observations.parked_work_vehicle == true
	local testimonyRecorded = state.wrenTestimonyRecorded
	local consentDecisionComplete = state.wrenDisclosureDecisionMade
	local consentPathComplete = if state.wrenSharePermission then state.pikeAdmissionRecorded else not state.pikeAdmissionRecorded
	return observationsComplete and testimonyRecorded and consentDecisionComplete and consentPathComplete
end

function RidgeviewInvestigationPolicy.Snapshot(state: State, catalog: { [string]: any }): { JournalEntry }
	local entries: { JournalEntry } = {}
	for noteId, recorded in state.observations do
		local definition = catalog[noteId]
		if recorded == true and definition ~= nil then
			table.insert(entries, {
				Id = definition.Id,
				Title = definition.Title,
				Text = definition.Text,
				Confidence = definition.Confidence,
				Category = "Observation",
				SortOrder = definition.SortOrder,
			})
		end
	end

	if state.wrenTestimonyRecorded then
		table.insert(entries, {
			Id = "wren_testimony_private",
			Title = "Wren's testimony",
			Text = "Wren reported seeing the repairman go toward the camp after an argument about the records. She did not follow him, cannot give an exact time, did not see him return, and does not know what happened to him.",
			Confidence = "Reported • First-hand account",
			Category = "Private testimony",
			SortOrder = 100,
		})
	end

	if state.wrenSharePermission then
		table.insert(entries, {
			Id = "wren_authorized_disclosure",
			Title = "Wren's authorized disclosure",
			Text = "Wren explicitly permitted sharing only this detail with Dorian Pike: she saw the repairman go toward the camp. No other part of her testimony is authorized for disclosure.",
			Confidence = "Permission granted • Narrow scope",
			Category = "Authorized disclosure",
			SortOrder = 110,
		})
	end

	if state.pikeAdmissionRecorded then
		table.insert(entries, {
			Id = "pike_limited_admission",
			Title = "Pike's limited admission",
			Text = "Dorian Pike said he kept people away from the camp because he thought fewer people going there would be safer. This records his stated reason; it does not establish every accusation or a legal finding.",
			Confidence = "Reported • NPC statement",
			Category = "NPC statement",
			SortOrder = 120,
		})
	end

	table.sort(entries, function(left: JournalEntry, right: JournalEntry): boolean
		return left.SortOrder < right.SortOrder
	end)
	return entries
end

return table.freeze(RidgeviewInvestigationPolicy)
