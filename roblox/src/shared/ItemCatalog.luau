--!strict
-- Stable civilian inventory IDs for the first construction-supply vertical slice.
-- Prices and live merchant stock are intentionally not defined here.

local definitions = {
	timber_plank = {
		Id = "timber_plank",
		DisplayName = "Timber Plank",
		Category = "BuildingMaterial",
		MaxStack = 50,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	stone_block = {
		Id = "stone_block",
		DisplayName = "Stone Block",
		Category = "BuildingMaterial",
		MaxStack = 50,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	glass_panel = {
		Id = "glass_panel",
		DisplayName = "Glass Panel",
		Category = "BuildingMaterial",
		MaxStack = 30,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	metal_fastener = {
		Id = "metal_fastener",
		DisplayName = "Metal Fastener",
		Category = "BuildingMaterial",
		MaxStack = 100,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	roof_tile = {
		Id = "roof_tile",
		DisplayName = "Roof Tile",
		Category = "BuildingMaterial",
		MaxStack = 50,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	paint_tin = {
		Id = "paint_tin",
		DisplayName = "Paint Tin",
		Category = "BuildingMaterial",
		MaxStack = 20,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	fabric_roll = {
		Id = "fabric_roll",
		DisplayName = "Fabric Roll",
		Category = "BuildingMaterial",
		MaxStack = 25,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
	basic_furniture_kit = {
		Id = "basic_furniture_kit",
		DisplayName = "Basic Furniture Kit",
		Category = "BuildingMaterial",
		MaxStack = 10,
		Tradeable = true,
		MerchantGroup = "BuildingSupply",
	},
}

for _, definition in definitions do
	table.freeze(definition)
end

return table.freeze(definitions)
