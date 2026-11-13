--!strict
-- Pure session-journal rules. No rewards, scores, persistence, or inference.

local RidgeviewFieldNotePolicy = {}

export type Journal = {[string]: boolean}

export type NoteSnapshot = {
	Id: string,
	Title: string,
	Text: string,
	Confidence: string,
	SortOrder: number,
}

function RidgeviewFieldNotePolicy.TryRecord(
	current: Journal,
	noteId: unknown,
	catalog: {[string]: any}
): (Journal?, string?)
	if typeof(noteId) ~= "string" then
		return nil, "Invalid field-note identifier."
	end

	if catalog[noteId] == nil then
		return nil, "Unknown field note."
	end

	if current[noteId] == true then
		return nil, "Field note already recorded."
	end

	local updated = table.clone(current)
	updated[noteId] = true
	return updated, nil
end

function RidgeviewFieldNotePolicy.Snapshot(
	journal: Journal,
	catalog: {[string]: any}
): {NoteSnapshot}
	local entries: {NoteSnapshot} = {}

	for noteId, recorded in journal do
		local definition = catalog[noteId]
		if recorded == true and definition ~= nil then
			table.insert(entries, {
				Id = definition.Id,
				Title = definition.Title,
				Text = definition.Text,
				Confidence = definition.Confidence,
				SortOrder = definition.SortOrder,
			})
		end
	end

	table.sort(entries, function(left: NoteSnapshot, right: NoteSnapshot): boolean
		return left.SortOrder < right.SortOrder
	end)

	return entries
end

return RidgeviewFieldNotePolicy
