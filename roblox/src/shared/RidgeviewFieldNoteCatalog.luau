--!strict
-- Approved Ridgeview approach observations for the Roblox vertical slice.
-- These are observations only; they do not assert ownership, cause, or conclusions.

export type FieldNoteDefinition = {
	Id: string,
	Title: string,
	Text: string,
	Confidence: string,
	SortOrder: number,
}

local definitions: {[string]: FieldNoteDefinition} = {
	approach_belongings = {
		Id = "approach_belongings",
		Title = "Belongings near the approach",
		Text = "A small collection of personal belongings has been left near the approach. Their owner and the reason they were left here are not established.",
		Confidence = "Observed",
		SortOrder = 1,
	},
	parked_work_vehicle = {
		Id = "parked_work_vehicle",
		Title = "Parked work vehicle",
		Text = "A work vehicle is parked near the approach, with a toolkit inside. The vehicle's owner and the reason it was left here are not established.",
		Confidence = "Observed",
		SortOrder = 2,
	},
}

for _, definition in definitions do
	table.freeze(definition)
end

return table.freeze(definitions)
