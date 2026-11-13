--!strict
-- Curated starter residential parcel definitions.
-- These are policy fixtures, not live purchasable land or final world placements.

local definitions = {
	ridgeview_residential_01 = {
		Id = "ridgeview_residential_01",
		DisplayName = "Ridgeview Plot 01",
		RegionId = "Ridgeview",
		PropertyType = "Residential",
		Width = 12,
		Depth = 12,
		MaxLayer = 3,
		MaxObjects = 120,
	},
	ridgeview_residential_02 = {
		Id = "ridgeview_residential_02",
		DisplayName = "Ridgeview Plot 02",
		RegionId = "Ridgeview",
		PropertyType = "Residential",
		Width = 12,
		Depth = 12,
		MaxLayer = 3,
		MaxObjects = 120,
	},
	ridgeview_residential_03 = {
		Id = "ridgeview_residential_03",
		DisplayName = "Ridgeview Plot 03",
		RegionId = "Ridgeview",
		PropertyType = "Residential",
		Width = 12,
		Depth = 12,
		MaxLayer = 3,
		MaxObjects = 120,
	},
}

for _, definition in definitions do
	table.freeze(definition)
end

return table.freeze(definitions)
