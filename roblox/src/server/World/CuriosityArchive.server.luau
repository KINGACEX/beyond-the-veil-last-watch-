--!strict
-- Optional Curiosity Archive: exploration-only secrets and a rotating display.
-- No story evidence, canon revelations, currency, paid access or mission progression.
-- Access is per-player and session-only until a reviewed persistence schema exists.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local ArchiveService = require(script.Parent.Parent.Services.ArchiveService)
local world = Workspace:WaitForChild("BTV_World")
local ridgeview = world:WaitForChild("Ridgeview_LandscapeStudy")

if ridgeview:FindFirstChild("CuriosityArchive") ~= nil then
	warn("[BTV Roblox] Curiosity Archive already exists; skipping duplicate build.")
	return
end

local origin = Vector3.new(460, 0, 0)
local archiveCenter = origin + Vector3.new(185, 0, -30)
local archive = Instance.new("Model")
archive.Name = "CuriosityArchive"
archive.Parent = ridgeview

local function makePart(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3, material: Enum.Material, canCollide: boolean?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material
	part.Anchored = true
	part.CanCollide = canCollide ~= false
	part.CanTouch = false
	part.CanQuery = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function addPrompt(part: BasePart, name: string, actionText: string, objectText: string, distance: number): ProximityPrompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = name
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.MaxActivationDistance = distance
	prompt.HoldDuration = 0
	prompt.RequiresLineOfSight = true
	prompt.Parent = part
	return prompt
end

local function addSign(parent: Instance, name: string, position: Vector3, text: string, width: number, height: number)
	local board = makePart(parent, name, Vector3.new(width, height, 0.5), position, Color3.fromRGB(29, 42, 51), Enum.Material.Slate, false)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.PixelsPerStud = 35
	gui.Parent = board
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(240, 226, 190)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextWrapped = true
	label.Parent = gui
end

-- Three optional discoveries are placed beside existing, non-story landmarks.
local marks = {
	{ id = "ridge_marker", name = "Ridge Curio Mark", position = origin + Vector3.new(55, 2, -65), hint = "Look near the trail marker." },
	{ id = "stream_marker", name = "Stream Curio Mark", position = origin + Vector3.new(-94, 2, 133), hint = "Look beside the stream." },
	{ id = "lookout_marker", name = "Lookout Curio Mark", position = origin + Vector3.new(132, 3, -65), hint = "Look around the lookout." },
}

for _, definition in marks do
	local token = makePart(ridgeview, "CurioMark_" .. definition.id, Vector3.new(1.2, 1.2, 1.2), definition.position, Color3.fromRGB(207, 170, 91), Enum.Material.Neon, false)
	token.Shape = Enum.PartType.Ball
	token:SetAttribute("BTVCurioMarkId", definition.id)
	local prompt = addPrompt(token, "InspectCurioMark", "Inspect", "Curio Mark", 8)
	prompt.Triggered:Connect(function(player: Player)
		if player.Character == nil or player:DistanceFromCharacter(token.Position) > 10 then
			return
		end
		local accepted, snapshot = ArchiveService.Collect(player, definition.id)
		if accepted and snapshot ~= nil then
			player:SetAttribute("BTVCurioMarks", snapshot.collectedCount)
			player:SetAttribute("BTVArchiveUnlocked", snapshot.unlocked)
		end
	end)
end

-- Room is physically sealed. Entry is a server-checked per-player teleport,
-- so one player's discovery never opens the barrier for everyone else.
local stone = Color3.fromRGB(65, 75, 79)
local floor = makePart(archive, "ArchiveFloor", Vector3.new(34, 1, 30), archiveCenter + Vector3.new(0, -0.5, 0), Color3.fromRGB(104, 99, 84), Enum.Material.Slate)
makePart(archive, "ArchiveBackWall", Vector3.new(34, 12, 1), archiveCenter + Vector3.new(0, 6, -15), stone, Enum.Material.Slate)
makePart(archive, "ArchiveLeftWall", Vector3.new(1, 12, 30), archiveCenter + Vector3.new(-17, 6, 0), stone, Enum.Material.Slate)
makePart(archive, "ArchiveRightWall", Vector3.new(1, 12, 30), archiveCenter + Vector3.new(17, 6, 0), stone, Enum.Material.Slate)
makePart(archive, "ArchiveRoof", Vector3.new(34, 1, 30), archiveCenter + Vector3.new(0, 12, 0), stone, Enum.Material.Slate)
local entryWall = makePart(archive, "LockedArchiveWall", Vector3.new(34, 12, 1), archiveCenter + Vector3.new(0, 6, 15), stone, Enum.Material.Slate)
addSign(archive, "ArchiveTitle", archiveCenter + Vector3.new(0, 9, 14.35), "THE CURIOSITY ARCHIVE", 18, 3)
addSign(archive, "ArchiveNotice", archiveCenter + Vector3.new(0, 5, 14.35), "Find all 3 Curio Marks to enter. Free for everyone.", 17, 2)

local entryTrigger = makePart(archive, "ArchiveEntryPromptAnchor", Vector3.new(3, 3, 1), archiveCenter + Vector3.new(0, 2, 18), Color3.new(1, 1, 1), Enum.Material.SmoothPlastic, false)
entryTrigger.Transparency = 1
local entryPrompt = addPrompt(entryTrigger, "EnterArchivePrompt", "Enter", "Curiosity Archive", 9)

local exitAnchor = makePart(archive, "ArchiveExitPromptAnchor", Vector3.new(3, 3, 1), archiveCenter + Vector3.new(0, 2, -12), Color3.new(1, 1, 1), Enum.Material.SmoothPlastic, false)
exitAnchor.Transparency = 1
local exitPrompt = addPrompt(exitAnchor, "ExitArchivePrompt", "Leave", "Return to Ridgeview", 9)

-- Decorative exhibits are non-canonical developer Easter eggs, not story objects.
local displayPositions = {
	archiveCenter + Vector3.new(-10, 1.4, -2),
	archiveCenter + Vector3.new(0, 1.4, -2),
	archiveCenter + Vector3.new(10, 1.4, -2),
}
for index, position in displayPositions do
	makePart(archive, "DisplayPlinth_" .. index, Vector3.new(5, 1, 5), position, Color3.fromRGB(49, 57, 61), Enum.Material.Metal, true)
	local orb = makePart(archive, "DisplayCurio_" .. index, Vector3.new(2, 2, 2), position + Vector3.new(0, 2, 0), Color3.fromRGB(188, 151, 79), Enum.Material.Neon, false)
	orb.Shape = Enum.PartType.Ball
end

local weeklyDisplay = addSign(archive, "WeeklyDisplay", archiveCenter + Vector3.new(0, 8, -14.35), "ROTATING DISPLAY\n" .. ArchiveService.GetDisplayTitle(), 20, 3)
weeklyDisplay.CFrame = CFrame.new(archiveCenter + Vector3.new(0, 8, -14.35)) * CFrame.Angles(0, math.pi, 0)

local function applySnapshot(player: Player)
	local snapshot = ArchiveService.GetSnapshot(player)
	if snapshot ~= nil then
		player:SetAttribute("BTVCurioMarks", snapshot.collectedCount)
		player:SetAttribute("BTVArchiveUnlocked", snapshot.unlocked)
		player:SetAttribute("BTVArchiveDisplay", snapshot.displayTitle)
	end
end

local function bindPlayer(player: Player)
	ArchiveService.AddPlayer(player)
	applySnapshot(player)
end

for _, player in Players:GetPlayers() do
	bindPlayer(player)
end
Players.PlayerAdded:Connect(bindPlayer)
Players.PlayerRemoving:Connect(function(player: Player)
	ArchiveService.RemovePlayer(player)
end)

entryPrompt.Triggered:Connect(function(player: Player)
	if player.Character == nil or player:DistanceFromCharacter(entryTrigger.Position) > 11 then
		return
	end
	local snapshot = ArchiveService.GetSnapshot(player)
	if snapshot == nil or not snapshot.unlocked then
		return
	end
	player.Character:PivotTo(CFrame.new(archiveCenter + Vector3.new(0, 3, 7)))
end)

exitPrompt.Triggered:Connect(function(player: Player)
	if player.Character == nil or player:DistanceFromCharacter(exitAnchor.Position) > 11 then
		return
	end
	player.Character:PivotTo(CFrame.new(archiveCenter + Vector3.new(0, 3, 21)))
end)

-- Keep references to authored room geometry alive for Studio inspection.
floor:SetAttribute("ArchiveStatus", "OPTIONAL EXPLORATION AREA • SESSION-ONLY UNLOCK")
entryWall:SetAttribute("PerPlayerAccess", true)
print("[BTV Roblox] Curiosity Archive built; three free discoveries, session-only access, rotating non-canon display.")
