--!strict
-- BTV Roblox visual prototype: Logos Rhema Temple.
-- This is an original, non-canon-locked environment study for the approved opening slice.
-- It deliberately avoids real-world HCI likenesses, named NPCs, invented service order,
-- Communion mechanics, and any claim that this is the final approved church architecture.

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local WORLD_NAME = "BTV_World"
local SCENE_NAME = "LogosRhemaTemple_VisualPrototype"

local world = Workspace:FindFirstChild(WORLD_NAME)
if world == nil then
	world = Instance.new("Folder")
	world.Name = WORLD_NAME
	world.Parent = Workspace
end

if world:FindFirstChild(SCENE_NAME) ~= nil then
	warn("[BTV Roblox] Logos Rhema Temple visual prototype already exists; skipping duplicate build.")
	return
end

local scene = Instance.new("Model")
scene.Name = SCENE_NAME
scene.Parent = world

local function makeModel(name: string, parent: Instance): Model
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	return model
end

local function makePart(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	material: Enum.Material,
	canCollide: boolean?,
	transparency: number?
): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.CanCollide = canCollide ~= false
	part.CastShadow = true
	part.Transparency = transparency or 0
	part.Parent = parent
	return part
end

local function makeLight(parent: Instance, name: string, position: Vector3, color: Color3, range: number, brightness: number)
	local holder = makePart(
		parent,
		name .. "_Housing",
		Vector3.new(2.4, 0.35, 2.4),
		CFrame.new(position),
		Color3.fromRGB(225, 218, 196),
		Enum.Material.SmoothPlastic,
		false
	)
	local light = Instance.new("PointLight")
	light.Name = name
	light.Color = color
	light.Range = range
	light.Brightness = brightness
	light.Shadows = true
	light.Parent = holder
end

local function makeTextSign(parent: Instance, name: string, position: Vector3, size: Vector3, title: string)
	local board = makePart(
		parent,
		name,
		size,
		CFrame.new(position),
		Color3.fromRGB(24, 35, 47),
		Enum.Material.Slate,
		false
	)
	local surface = Instance.new("SurfaceGui")
	surface.Name = "SignSurface"
	surface.Face = Enum.NormalId.Front
	surface.LightInfluence = 0
	surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surface.PixelsPerStud = 45
	surface.Parent = board

	local label = Instance.new("TextLabel")
	label.Name = "SignText"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = title
	label.TextColor3 = Color3.fromRGB(245, 240, 224)
	label.TextScaled = true
	label.TextWrapped = true
	label.Parent = surface

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(184, 151, 87)
	stroke.Thickness = 1.2
	stroke.Parent = label
	return board
end

local structure = makeModel("Architecture", scene)
local interior = makeModel("Interior", scene)
local exterior = makeModel("ApproachAndLandscaping", scene)
local lightingRig = makeModel("Lighting", scene)

-- Palette: contemporary stone, warm timber, restrained blue and gold.
local stone = Color3.fromRGB(202, 204, 199)
local paleStone = Color3.fromRGB(226, 225, 214)
local darkStone = Color3.fromRGB(45, 57, 68)
local timber = Color3.fromRGB(104, 78, 55)
local warmGold = Color3.fromRGB(177, 145, 83)
local glassBlue = Color3.fromRGB(108, 148, 166)
local floorTone = Color3.fromRGB(171, 174, 170)

-- Main sanctuary and attached foyer floor.
makePart(structure, "SanctuaryFoundation", Vector3.new(116, 2, 98), CFrame.new(0, -1, 10), darkStone, Enum.Material.Concrete)
makePart(structure, "SanctuaryFloor", Vector3.new(110, 0.5, 92), CFrame.new(0, 0.25, 10), floorTone, Enum.Material.Marble)
makePart(structure, "FoyerFoundation", Vector3.new(62, 2, 34), CFrame.new(0, -1, -54), darkStone, Enum.Material.Concrete)
makePart(structure, "FoyerFloor", Vector3.new(58, 0.5, 32), CFrame.new(0, 0.25, -54), paleStone, Enum.Material.Marble)

-- Sanctuary side walls: solid lower/upper bands with tall glazing between.
for _, side in {-1, 1} do
	local x = side * 55
	for _, z in {-30, -12, 6, 24, 42} do
		makePart(
			structure,
			"SideWallLower_" .. side .. "_" .. z,
			Vector3.new(2, 8, 15.5),
			CFrame.new(x, 4.5, z),
			stone,
			Enum.Material.Concrete
		)
	end
	makePart(
		structure,
		"SideWallUpper_" .. side,
		Vector3.new(2, 7, 92),
		CFrame.new(x, 22, 10),
		paleStone,
		Enum.Material.Concrete
	)
	for _, z in {-21, -3, 15, 33} do
		makePart(
			structure,
			"HighWindow_" .. side .. "_" .. z,
			Vector3.new(0.6, 9, 13.5),
			CFrame.new(x, 13, z),
			glassBlue,
			Enum.Material.Glass,
			false,
			0.28
		)
		makePart(
			structure,
			"WindowSill_" .. side .. "_" .. z,
			Vector3.new(2.5, 0.55, 14),
			CFrame.new(x, 8.3, z),
			warmGold,
			Enum.Material.Metal,
			false
		)
	end
end

-- Rear wall and front sanctuary wall, with a broad central opening to the foyer.
makePart(structure, "RearWall", Vector3.new(112, 25, 2), CFrame.new(0, 12.5, 56), stone, Enum.Material.Concrete)
makePart(structure, "FrontWallLeft", Vector3.new(39, 22, 2), CFrame.new(-35.5, 11, -36), stone, Enum.Material.Concrete)
makePart(structure, "FrontWallRight", Vector3.new(39, 22, 2), CFrame.new(35.5, 11, -36), stone, Enum.Material.Concrete)
makePart(structure, "FrontWallHeader", Vector3.new(32, 5, 2), CFrame.new(0, 21, -36), paleStone, Enum.Material.Concrete)

-- Foyer enclosure and contemporary entrance frame.
makePart(structure, "FoyerLeftWall", Vector3.new(2, 16, 32), CFrame.new(-29, 8, -54), stone, Enum.Material.Concrete)
makePart(structure, "FoyerRightWall", Vector3.new(2, 16, 32), CFrame.new(29, 8, -54), stone, Enum.Material.Concrete)
makePart(structure, "FoyerFrontLeft", Vector3.new(18, 16, 2), CFrame.new(-20, 8, -70), stone, Enum.Material.Concrete)
makePart(structure, "FoyerFrontRight", Vector3.new(18, 16, 2), CFrame.new(20, 8, -70), stone, Enum.Material.Concrete)
makePart(structure, "FoyerFrontHeader", Vector3.new(24, 3, 2), CFrame.new(0, 15, -70), paleStone, Enum.Material.Concrete)
makePart(structure, "EntranceGlassLeft", Vector3.new(0.35, 12, 8), CFrame.new(-8.5, 6.5, -70), glassBlue, Enum.Material.Glass, false, 0.25)
makePart(structure, "EntranceGlassRight", Vector3.new(0.35, 12, 8), CFrame.new(8.5, 6.5, -70), glassBlue, Enum.Material.Glass, false, 0.25)
makePart(structure, "EntranceCanopy", Vector3.new(36, 1.4, 12), CFrame.new(0, 16.4, -74), darkStone, Enum.Material.Slate)
makePart(structure, "CanopyGoldTrim", Vector3.new(36, 0.25, 0.45), CFrame.new(0, 15.65, -79.6), warmGold, Enum.Material.Metal, false)

-- Flat modern roof with a clean perimeter fascia.
makePart(structure, "MainRoof", Vector3.new(120, 2.5, 102), CFrame.new(0, 26.5, 10), darkStone, Enum.Material.Slate)
makePart(structure, "RoofGoldFrontTrim", Vector3.new(118, 0.35, 0.5), CFrame.new(0, 25.1, -41), warmGold, Enum.Material.Metal, false)
makePart(structure, "RoofGoldRearTrim", Vector3.new(118, 0.35, 0.5), CFrame.new(0, 25.1, 61), warmGold, Enum.Material.Metal, false)

-- Structural columns and ceiling beams create readable depth without excessive geometry.
for _, x in {-49, -34, 34, 49} do
	for _, z in {-31, 0, 31, 51} do
		makePart(
			structure,
			"InteriorColumn_" .. x .. "_" .. z,
			Vector3.new(1.5, 23, 1.5),
			CFrame.new(x, 11.5, z),
			paleStone,
			Enum.Material.Marble
		)
	end
end
for _, z in {-25, 0, 25, 50} do
	makePart(structure, "CeilingBeam_" .. z, Vector3.new(108, 0.8, 1.4), CFrame.new(0, 24.4, z), timber, Enum.Material.Wood)
end

-- Sanctuary focal wall and understated cross. This is environmental architecture, not a power object.
makePart(interior, "SanctuaryFeatureWall", Vector3.new(48, 17, 1.2), CFrame.new(0, 15, 54.6), darkStone, Enum.Material.Slate)
makePart(interior, "CrossVertical", Vector3.new(1.4, 9, 0.7), CFrame.new(0, 16, 53.7), warmGold, Enum.Material.Metal, false)
makePart(interior, "CrossHorizontal", Vector3.new(6, 1.4, 0.7), CFrame.new(0, 17.7, 53.7), warmGold, Enum.Material.Metal, false)

-- Raised front platform, lectern and an unadorned Communion table.
makePart(interior, "PlatformBase", Vector3.new(42, 1.1, 12), CFrame.new(0, 0.8, 39), timber, Enum.Material.WoodPlanks)
makePart(interior, "PlatformTop", Vector3.new(40, 0.35, 11), CFrame.new(0, 1.5, 39), paleStone, Enum.Material.Marble)
makePart(interior, "LecternFoot", Vector3.new(3.5, 0.5, 2.5), CFrame.new(-12, 1.95, 37), timber, Enum.Material.Wood)
makePart(interior, "LecternStem", Vector3.new(1.1, 3.2, 1.1), CFrame.new(-12, 3.6, 37), timber, Enum.Material.Wood)
makePart(interior, "LecternTop", Vector3.new(4.4, 0.45, 3), CFrame.new(-12, 5.35, 37), timber, Enum.Material.Wood)
makePart(interior, "CommunionTableTop", Vector3.new(8, 0.5, 3), CFrame.new(8, 2.1, 40), timber, Enum.Material.WoodPlanks)
for _, x in {5, 11} do
	for _, z in {39, 41} do
		makePart(interior, "CommunionTableLeg_" .. x .. "_" .. z, Vector3.new(0.35, 2, 0.35), CFrame.new(x, 1, z), timber, Enum.Material.Wood)
	end
end

-- Seating: two balanced blocks with a clear central aisle.
local function makeBench(parent: Instance, name: string, center: Vector3, length: number)
	makePart(parent, name .. "_Seat", Vector3.new(length, 0.55, 2.2), CFrame.new(center + Vector3.new(0, 2.2, 0)), timber, Enum.Material.WoodPlanks)
	makePart(parent, name .. "_Back", Vector3.new(length, 2.4, 0.55), CFrame.new(center + Vector3.new(0, 3.35, 0.85)), timber, Enum.Material.Wood)
	for _, xOffset in {-length / 2 + 1, length / 2 - 1} do
		makePart(parent, name .. "_Leg_" .. xOffset, Vector3.new(0.55, 2.1, 1.5), CFrame.new(center + Vector3.new(xOffset, 1.05, 0)), darkStone, Enum.Material.Metal)
	end
end

for row, z in ipairs({-25, -16, -7, 2, 11, 20}) do
	makeBench(interior, "LeftBench_" .. row, Vector3.new(-26, 0, z), 32)
	makeBench(interior, "RightBench_" .. row, Vector3.new(26, 0, z), 32)
end

-- Warm ceiling fixtures; restrained lighting keeps the space readable.
for index, z in ipairs({-24, -2, 20, 43}) do
	makeLight(lightingRig, "SanctuaryWarmLight_" .. index, Vector3.new(0, 22.5, z), Color3.fromRGB(255, 232, 196), 38, 1.15)
end
makeLight(lightingRig, "FoyerWarmLight", Vector3.new(0, 13, -53), Color3.fromRGB(255, 226, 188), 28, 1.0)

-- Foyer details and approved fictional church signage.
makePart(interior, "WelcomeDesk", Vector3.new(14, 2.2, 3), CFrame.new(0, 1.6, -48), timber, Enum.Material.WoodPlanks)
makePart(interior, "WelcomeDeskFront", Vector3.new(14, 1.2, 0.3), CFrame.new(0, 1.5, -46.35), darkStone, Enum.Material.Slate, false)
makeTextSign(interior, "TempleNameSign", Vector3.new(0, 19.1, -71.2), Vector3.new(20, 3.2, 0.5), "LOGOS RHEMA TEMPLE")

-- Exterior forecourt and path.
makePart(exterior, "ForecourtGround", Vector3.new(180, 1, 100), CFrame.new(0, -1.7, -104), Color3.fromRGB(79, 105, 77), Enum.Material.Grass)
makePart(exterior, "EntryWalkway", Vector3.new(18, 0.35, 42), CFrame.new(0, -0.85, -91), paleStone, Enum.Material.Concrete)
for _, x in {-15, 15} do
	makePart(exterior, "ApproachPlanter_" .. x, Vector3.new(7, 1.2, 22), CFrame.new(x, -0.25, -91), darkStone, Enum.Material.Slate)
	for index, z in ipairs({-98, -91, -84}) do
		local shrub = makePart(
			exterior,
			"PlanterShrub_" .. x .. "_" .. index,
			Vector3.new(3.4, 2.2, 3.4),
			CFrame.new(x, 1.2, z),
			Color3.fromRGB(58, 103, 69),
			Enum.Material.Grass,
			false
		)
		shrub.Shape = Enum.PartType.Ball
	end
end

-- Small, low-cost trees establish a soft edge to the approach.
for index, position in ipairs({
	Vector3.new(-72, 0, -88),
	Vector3.new(72, 0, -88),
	Vector3.new(-78, 0, -112),
	Vector3.new(78, 0, -112),
	Vector3.new(-64, 0, -132),
	Vector3.new(64, 0, -132),
}) do
	local tree = makeModel("Tree_" .. index, exterior)
	local trunk = makePart(tree, "Trunk", Vector3.new(11, 2.2, 2.2), CFrame.new(position + Vector3.new(0, 5.5, 0)) * CFrame.Angles(0, 0, math.rad(90)), timber, Enum.Material.Wood)
	trunk.Shape = Enum.PartType.Cylinder
	for crown = 1, 3 do
		local offset = Vector3.new((crown - 2) * 2.5, 11 + crown * 1.4, (crown % 2) * 1.6)
		local leaves = makePart(
			tree,
			"Canopy_" .. crown,
			Vector3.new(8, 7, 8),
			CFrame.new(position + offset),
			Color3.fromRGB(55 + crown * 5, 101 + crown * 4, 66),
			Enum.Material.Grass,
			false
		)
		leaves.Shape = Enum.PartType.Ball
	end
end

-- A neutral spawn point places the first prototype session in the foyer.
local spawn = Instance.new("SpawnLocation")
spawn.Name = "PrototypeFoyerSpawn"
spawn.Size = Vector3.new(5, 0.5, 5)
spawn.CFrame = CFrame.new(0, 0.8, -56)
spawn.Transparency = 1
spawn.CanCollide = false
spawn.Anchored = true
spawn.Neutral = true
spawn.Duration = 0
spawn.Parent = scene

-- Scene-local metadata makes its prototype status visible to future maintainers.
local status = Instance.new("StringValue")
status.Name = "Status"
status.Value = "VISUAL PROTOTYPE — proposed layout; not canon-locked or Studio-verified"
status.Parent = scene

print("[BTV Roblox] Logos Rhema Temple visual prototype assembled in Workspace/BTV_World.")
