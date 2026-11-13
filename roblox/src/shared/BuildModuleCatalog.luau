--!strict
-- Server-approved modular residential construction kit.
-- Material costs and Robux prices are deliberately unset pending economy balancing.

local definitions = {
	foundation_tile = {
		Id = "foundation_tile",
		DisplayName = "Foundation Tile",
		Category = "Foundation",
		FootprintX = 2,
		FootprintZ = 2,
		Layer = 0,
		SupportLayer = nil,
		MaxPerParcel = 12,
	},
	floor_tile = {
		Id = "floor_tile",
		DisplayName = "Floor Tile",
		Category = "Floor",
		FootprintX = 1,
		FootprintZ = 1,
		Layer = 0,
		SupportLayer = nil,
		MaxPerParcel = 120,
	},
	wall_panel = {
		Id = "wall_panel",
		DisplayName = "Wall Panel",
		Category = "Wall",
		FootprintX = 2,
		FootprintZ = 1,
		Layer = 1,
		SupportLayer = 0,
		MaxPerParcel = 80,
	},
	door_frame = {
		Id = "door_frame",
		DisplayName = "Door Frame",
		Category = "Door",
		FootprintX = 1,
		FootprintZ = 1,
		Layer = 1,
		SupportLayer = 0,
		MaxPerParcel = 12,
	},
	window_panel = {
		Id = "window_panel",
		DisplayName = "Window Panel",
		Category = "Window",
		FootprintX = 1,
		FootprintZ = 1,
		Layer = 1,
		SupportLayer = 0,
		MaxPerParcel = 32,
	},
	roof_panel = {
		Id = "roof_panel",
		DisplayName = "Roof Panel",
		Category = "Roof",
		FootprintX = 2,
		FootprintZ = 1,
		Layer = 2,
		SupportLayer = 1,
		MaxPerParcel = 80,
	},
	stair_module = {
		Id = "stair_module",
		DisplayName = "Stair Module",
		Category = "Stairs",
		FootprintX = 1,
		FootprintZ = 2,
		Layer = 1,
		SupportLayer = 0,
		MaxPerParcel = 12,
	},
	table = {
		Id = "table",
		DisplayName = "Table",
		Category = "Furniture",
		FootprintX = 2,
		FootprintZ = 1,
		Layer = 3,
		SupportLayer = 0,
		MaxPerParcel = 20,
	},
	chair = {
		Id = "chair",
		DisplayName = "Chair",
		Category = "Furniture",
		FootprintX = 1,
		FootprintZ = 1,
		Layer = 3,
		SupportLayer = 0,
		MaxPerParcel = 40,
	},
	lamp = {
		Id = "lamp",
		DisplayName = "Lamp",
		Category = "Lighting",
		FootprintX = 1,
		FootprintZ = 1,
		Layer = 3,
		SupportLayer = 0,
		MaxPerParcel = 30,
	},
}

for _, definition in definitions do
	table.freeze(definition)
end

return table.freeze(definitions)
