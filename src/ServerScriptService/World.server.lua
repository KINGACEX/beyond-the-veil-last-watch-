local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local oldWorld = Workspace:FindFirstChild("LastWatchWorld")
if oldWorld then
	oldWorld:Destroy()
end

local world = Instance.new("Folder")
world.Name = "LastWatchWorld"
world.Parent = Workspace

local function makePart(name, size, position, color, material, anchored)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material or Enum.Material.Concrete
	part.Anchored = anchored ~= false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = world
	return part
end

-- A small, self-contained blockout level that works without imported assets.
makePart("Ground", Vector3.new(240, 2, 240), Vector3.new(0, -1, 0), Color3.fromRGB(54, 74, 57), Enum.Material.Grass)
makePart("Path", Vector3.new(18, 0.2, 76), Vector3.new(0, 0.1, -28), Color3.fromRGB(112, 101, 83), Enum.Material.Ground)

local spawn = Instance.new("SpawnLocation")
spawn.Name = "WatchPostSpawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(0, 1.6, 25)
spawn.Color = Color3.fromRGB(105, 127, 108)
spawn.Material = Enum.Material.Slate
spawn.Anchored = true
spawn.Neutral = true
spawn.Duration = 0
spawn.Parent = world

-- Ruined walls frame the path and the watch bell.
makePart("WestRuinedWall", Vector3.new(3, 14, 36), Vector3.new(-18, 7, -38), Color3.fromRGB(91, 87, 77), Enum.Material.Slate)
makePart("EastRuinedWall", Vector3.new(3, 10, 28), Vector3.new(18, 5, -42), Color3.fromRGB(91, 87, 77), Enum.Material.Slate)
makePart("NorthWallLeft", Vector3.new(21, 12, 3), Vector3.new(-10.5, 6, -58), Color3.fromRGB(91, 87, 77), Enum.Material.Slate)
makePart("NorthWallRight", Vector3.new(21, 12, 3), Vector3.new(10.5, 6, -58), Color3.fromRGB(91, 87, 77), Enum.Material.Slate)

local altar = makePart("WatchBellAltar", Vector3.new(8, 3, 8), Vector3.new(0, 1.5, -47), Color3.fromRGB(73, 71, 66), Enum.Material.Cobblestone)
local bell = makePart("WatchBell", Vector3.new(3, 5, 3), Vector3.new(0, 5.5, -47), Color3.fromRGB(177, 143, 72), Enum.Material.Metal)
bell.Shape = Enum.PartType.Cylinder
bell.Orientation = Vector3.new(0, 0, 90)

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Ring the bell"
prompt.ObjectText = "The Last Watch"
prompt.HoldDuration = 1
prompt.MaxActivationDistance = 12
prompt.Parent = bell

local event = ReplicatedStorage:FindFirstChild("WatchObjectiveEvent")
if not event then
	event = Instance.new("RemoteEvent")
	event.Name = "WatchObjectiveEvent"
	event.Parent = ReplicatedStorage
end

local rung = false
prompt.Triggered:Connect(function(player)
	if rung then
		event:FireClient(player, "The watch bell has already been rung. The Last Watch is underway.")
		return
	end

	rung = true
	prompt.Enabled = false
	bell.Color = Color3.fromRGB(255, 215, 115)
	local light = Instance.new("PointLight")
	light.Color = bell.Color
	light.Brightness = 3
	light.Range = 24
	light.Parent = bell
	event:FireAllClients(player.DisplayName .. " rang the bell. The Last Watch has begun!")
end)

Lighting.ClockTime = 19
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(95, 105, 125)
Lighting.OutdoorAmbient = Color3.fromRGB(80, 90, 110)
Lighting.FogColor = Color3.fromRGB(60, 72, 83)
Lighting.FogEnd = 450

print("Last Watch blockout loaded. Find the bell beyond the ruined walls.")
