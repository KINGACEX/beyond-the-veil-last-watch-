--!strict
-- BTV Roblox: Ridgeview landscape study.
-- A modular visual study only. Ridgeview geography, settlement layout and mission facts
-- remain unapproved; this scene deliberately adds no named residents, clues or story props.

local Workspace = game:GetService("Workspace")

local WORLD_NAME = "BTV_World"
local SCENE_NAME = "Ridgeview_LandscapeStudy"
local ORIGIN = Vector3.new(460, 0, 0)

local world = Workspace:FindFirstChild(WORLD_NAME)
if world == nil then
	world = Instance.new("Folder")
	world.Name = WORLD_NAME
	world.Parent = Workspace
end

if world:FindFirstChild(SCENE_NAME) ~= nil then
	warn("[BTV Roblox] Ridgeview landscape study already exists; skipping duplicate build.")
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
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.CanCollide = canCollide ~= false
	part.CastShadow = true
	part.Transparency = transparency or 0
	part.Parent = parent
	return part
end

local function makeRibbon(
	parent: Instance,
	name: string,
	startPoint: Vector3,
	endPoint: Vector3,
	width: number,
	thickness: number,
	color: Color3,
	material: Enum.Material,
	canCollide: boolean?
): Part
	local midpoint = (startPoint + endPoint) / 2
	local length = (endPoint - startPoint).Magnitude
	return makePart(
		parent,
		name,
		Vector3.new(width, thickness, length),
		CFrame.lookAt(midpoint, endPoint),
		color,
		material,
		canCollide
	)
end

local terrain = makeModel("TerrainForms", scene)
local routes = makeModel("RoadAndFootpaths", scene)
local vegetation = makeModel("Woodland", scene)
local lookout = makeModel("RidgeLookout", scene)
local details = makeModel("NaturalDetails", scene)

local grass = Color3.fromRGB(72, 105, 74)
local grassLight = Color3.fromRGB(94, 126, 82)
local grassDark = Color3.fromRGB(49, 79, 61)
local stone = Color3.fromRGB(111, 111, 101)
local rockLight = Color3.fromRGB(139, 137, 121)
local bark = Color3.fromRGB(91, 66, 48)
local leafA = Color3.fromRGB(42, 91, 58)
local leafB = Color3.fromRGB(56, 112, 66)
local roadColor = Color3.fromRGB(49, 54, 57)
local pathColor = Color3.fromRGB(151, 142, 119)
local waterColor = Color3.fromRGB(76, 132, 151)

-- Ground plane and overlapping hill masses create a broad, readable outdoor vista.
makePart(
	terrain,
	"LandscapeBase",
	Vector3.new(560, 4, 420),
	CFrame.new(ORIGIN + Vector3.new(0, -2, 0)),
	grass,
	Enum.Material.Grass
)

local hills = {
	{Vector3.new(-175, 20, -145), Vector3.new(190, 72, 115), grassDark},
	{Vector3.new(-45, 28, -174), Vector3.new(210, 88, 132), grass},
	{Vector3.new(105, 24, -150), Vector3.new(200, 78, 120), grassDark},
	{Vector3.new(220, 17, -105), Vector3.new(145, 58, 110), grassLight},
	{Vector3.new(-190, 14, 100), Vector3.new(150, 52, 100), grassLight},
	{Vector3.new(205, 19, 125), Vector3.new(175, 62, 118), grass},
}

for index, hill in hills do
	local mound = makePart(
		terrain,
		"RidgeMass_" .. index,
		hill[2],
		CFrame.new(ORIGIN + hill[1]),
		hill[3],
		Enum.Material.Grass,
		false
	)
	mound.Shape = Enum.PartType.Ball
end

-- Layered stone outcrops break up the grassy ridge silhouettes.
for index, data in {
	{Vector3.new(-178, 10, -44), Vector3.new(32, 18, 24)},
	{Vector3.new(-122, 8, -68), Vector3.new(25, 14, 18)},
	{Vector3.new(172, 12, -52), Vector3.new(38, 20, 27)},
	{Vector3.new(205, 8, 24), Vector3.new(26, 15, 22)},
	{Vector3.new(-205, 7, 95), Vector3.new(35, 18, 24)},
	{Vector3.new(92, 8, 152), Vector3.new(28, 16, 22)},
} do
	local rock = makePart(
		details,
		"StoneOutcrop_" .. index,
		data[2],
		CFrame.new(ORIGIN + data[1]) * CFrame.Angles(0, math.rad(index * 17), math.rad((index % 3 - 1) * 9)),
		index % 2 == 0 and rockLight or stone,
		Enum.Material.Rock,
		false
	)
	rock.Shape = Enum.PartType.Ball
end

-- A broad, gently curving road and a separate footpath establish traversal scale.
local roadPoints = {
	Vector3.new(-260, 0.35, 142),
	Vector3.new(-180, 0.35, 104),
	Vector3.new(-88, 0.35, 82),
	Vector3.new(5, 0.35, 28),
	Vector3.new(94, 0.35, -5),
	Vector3.new(178, 0.35, -45),
	Vector3.new(255, 0.35, -102),
}

for index = 1, #roadPoints - 1 do
	local a = ORIGIN + roadPoints[index]
	local b = ORIGIN + roadPoints[index + 1]
	makeRibbon(routes, "RoadSegment_" .. index, a, b, 19, 0.55, roadColor, Enum.Material.Asphalt)
	makeRibbon(routes, "RoadShoulder_" .. index, a + Vector3.new(0, -0.12, 0), b + Vector3.new(0, -0.12, 0), 25, 0.28, stone, Enum.Material.Ground, false)
end

local trailPoints = {
	Vector3.new(-38, 0.22, 35),
	Vector3.new(-8, 0.22, 12),
	Vector3.new(26, 0.22, -25),
	Vector3.new(55, 0.22, -63),
	Vector3.new(76, 0.22, -98),
	Vector3.new(98, 0.22, -122),
}

for index = 1, #trailPoints - 1 do
	makeRibbon(
		routes,
		"FootpathSegment_" .. index,
		ORIGIN + trailPoints[index],
		ORIGIN + trailPoints[index + 1],
		7,
		0.32,
		pathColor,
		Enum.Material.Ground,
		true
	)
end

-- A narrow stream is a visual landmark only; it has no collection or gameplay function.
local streamPoints = {
	Vector3.new(-132, 0.12, 166),
	Vector3.new(-94, 0.12, 133),
	Vector3.new(-52, 0.12, 116),
	Vector3.new(-14, 0.12, 91),
}
for index = 1, #streamPoints - 1 do
	makeRibbon(
		details,
		"StreamSurface_" .. index,
		ORIGIN + streamPoints[index],
		ORIGIN + streamPoints[index + 1],
		8,
		0.22,
		waterColor,
		Enum.Material.Glass,
		false
	)
end

-- Reusable low-poly tree clusters. Trunks are collidable; crowns are not.
local treePositions = {
	Vector3.new(-225, 0, -38),
	Vector3.new(-202, 0, -92),
	Vector3.new(-154, 0, -126),
	Vector3.new(-110, 0, -98),
	Vector3.new(-70, 0, -142),
	Vector3.new(-28, 0, -156),
	Vector3.new(24, 0, -143),
	Vector3.new(74, 0, -160),
	Vector3.new(130, 0, -120),
	Vector3.new(178, 0, -92),
	Vector3.new(224, 0, -42),
	Vector3.new(-222, 0, 72),
	Vector3.new(-177, 0, 125),
	Vector3.new(-118, 0, 164),
	Vector3.new(147, 0, 140),
	Vector3.new(198, 0, 91),
	Vector3.new(235, 0, 43),
}

for index, offset in treePositions do
	local tree = makeModel("RidgeTree_" .. index, vegetation)
	local base = ORIGIN + offset
	local height = 9 + (index % 4) * 1.4
	local trunk = makePart(
		tree,
		"Trunk",
		Vector3.new(2.1, height, 2.1),
		CFrame.new(base + Vector3.new(0, height / 2, 0)) * CFrame.Angles(0, 0, math.rad(90)),
		bark,
		Enum.Material.Wood
	)
	trunk.Shape = Enum.PartType.Cylinder

	for crown = 1, 3 do
		local canopy = makePart(
			tree,
			"Canopy_" .. crown,
			Vector3.new(8.5, 7.5, 8.5),
			CFrame.new(base + Vector3.new((crown - 2) * 2.4, height + crown * 1.1, (crown % 2) * 1.8)),
			crown % 2 == 0 and leafA or leafB,
			Enum.Material.Grass,
			false
		)
		canopy.Shape = Enum.PartType.Ball
	end
end

-- A modest overlook gives the landscape a clear visual destination.
local deckCenter = ORIGIN + Vector3.new(103, -0.5, -128)
makePart(lookout, "LookoutStonePad", Vector3.new(42, 1.5, 34), deckCenter, stone, Enum.Material.Slate)
makePart(lookout, "LookoutDeck", Vector3.new(34, 0.8, 27), deckCenter + Vector3.new(0, 1.15, 0), bark, Enum.Material.WoodPlanks)

for _, x in {-16, 16} do
	makePart(
		lookout,
		"LookoutRail_" .. x,
		Vector3.new(0.6, 4.2, 27),
		deckCenter + Vector3.new(x, 3.5, 0),
		bark,
		Enum.Material.Wood
	)
end
for _, z in {-13, 13} do
	makePart(
		lookout,
		"LookoutRailEnd_" .. z,
		Vector3.new(34, 4.2, 0.6),
		deckCenter + Vector3.new(0, 3.5, z),
		bark,
		Enum.Material.Wood
	)
end

-- Simple, non-interactive trail posts. No mission clues or narrative text are authored here.
for index, position in {
	Vector3.new(56, 0, -65),
	Vector3.new(91, 0, -116),
} do
	makePart(
		details,
		"TrailPost_" .. index,
		Vector3.new(0.65, 4.5, 0.65),
		ORIGIN + position + Vector3.new(0, 2.25, 0),
		bark,
		Enum.Material.Wood
	)
end

local status = Instance.new("StringValue")
status.Name = "Status"
status.Value = "ENVIRONMENT STUDY — proposed geography; no canon, mission facts or authored evidence"
status.Parent = scene

print("[BTV Roblox] Ridgeview landscape study assembled in Workspace/BTV_World.")
