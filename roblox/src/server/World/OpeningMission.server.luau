--!strict
-- First playable opening-slice interaction scaffold.
-- Communion remains contextual. No evidence, dialogue, rewards, or theology-dependent
-- mechanics are fabricated here; the Scout Report content is deliberately pending.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local MissionService = require(script.Parent.Parent.Services.MissionService)
local remoteFolder = ReplicatedStorage:WaitForChild("BTVRemotes")
local missionStateUpdated = remoteFolder:WaitForChild("MissionStateUpdated") :: RemoteEvent

local world = Workspace:WaitForChild("BTV_World")
local scene = world:WaitForChild("LogosRhemaTemple_VisualPrototype")
local interior = scene:WaitForChild("Interior")
local ridgeviewScene = world:WaitForChild("Ridgeview_LandscapeStudy")
local ridgeviewArrivalMarker = ridgeviewScene:WaitForChild("RidgeviewArrivalMarker") :: BasePart

local function getRidgeviewArrivalCFrame(): CFrame
	local position = ridgeviewArrivalMarker.Position + Vector3.new(0, 3.5, 0)
	return CFrame.lookAt(position, position + Vector3.new(30, 0, -23))
end

local function addPrompt(parent: BasePart, name: string, actionText: string, objectText: string): ProximityPrompt
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("ProximityPrompt") then
		return existing
	end
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = name
	prompt.ActionText = actionText
	prompt.ObjectText = objectText
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 10
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
	prompt.Parent = parent
	return prompt
end

local function publish(player: Player, expectedPhase: string, nextPhase: string)
	local accepted, snapshot = MissionService.Advance(player, expectedPhase, nextPhase)
	if accepted and snapshot ~= nil then
		missionStateUpdated:FireClient(player, snapshot)
	end
end

local sanctuaryThreshold = Instance.new("Part")
sanctuaryThreshold.Name = "SanctuaryEntryInteraction"
sanctuaryThreshold.Size = Vector3.new(8, 1, 2)
sanctuaryThreshold.CFrame = CFrame.new(0, 1.5, -35)
sanctuaryThreshold.Anchored = true
sanctuaryThreshold.Transparency = 1
sanctuaryThreshold.CanCollide = false
sanctuaryThreshold.CanTouch = false
sanctuaryThreshold.Parent = scene

local enterPrompt = addPrompt(sanctuaryThreshold, "EnterSanctuaryPrompt", "Enter", "Sanctuary")
enterPrompt.Triggered:Connect(function(player: Player)
	if player.Character == nil or player:DistanceFromCharacter(sanctuaryThreshold.Position) > 13 then
		return
	end
	publish(player, "communion_context", "covenant_alert")
end)

local welcomeDesk = interior:WaitForChild("WelcomeDesk") :: BasePart
local reportPrompt = addPrompt(welcomeDesk, "OpenScoutReportPrompt", "Open", "Scout Report")
reportPrompt.Triggered:Connect(function(player: Player)
	if player.Character == nil or player:DistanceFromCharacter(welcomeDesk.Position) > 13 then
		return
	end
	publish(player, "covenant_alert", "report_accessed")
end)

-- Keep players at the correct opening-slice location after character respawns.
-- Mission phase remains server-owned and session-only; this restores position, not progress.
local characterConnections: { [number]: RBXScriptConnection } = {}

local function restoreRidgeviewPosition(player: Player, character: Model)
	task.defer(function()
		local root = character:WaitForChild("HumanoidRootPart", 10)
		if root == nil or player.Parent ~= Players or player.Character ~= character then
			return
		end

		local snapshot = MissionService.GetSnapshot(player)
		if snapshot ~= nil and snapshot.phase == "ridgeview_arrival" then
			character:PivotTo(getRidgeviewArrivalCFrame())
		end
	end)
end

local function bindPlayer(player: Player)
	local previous = characterConnections[player.UserId]
	if previous ~= nil then
		previous:Disconnect()
	end

	characterConnections[player.UserId] = player.CharacterAdded:Connect(function(character: Model)
		restoreRidgeviewPosition(player, character)
	end)

	if player.Character ~= nil then
		restoreRidgeviewPosition(player, player.Character)
	end

	task.defer(function()
		if player.Parent == Players then
			local snapshot = MissionService.GetSnapshot(player)
			if snapshot ~= nil then
				missionStateUpdated:FireClient(player, snapshot)
			end
		end
	end)
end

for _, player in Players:GetPlayers() do
	bindPlayer(player)
end
Players.PlayerAdded:Connect(bindPlayer)
Players.PlayerRemoving:Connect(function(player: Player)
	local connection = characterConnections[player.UserId]
	if connection ~= nil then
		connection:Disconnect()
		characterConnections[player.UserId] = nil
	end
end)

-- Travel is unlocked only after the player has opened the Scout Report.
-- The destination is the scene-owned Ridgeview arrival marker; this does not
-- author any investigation facts or evidence.
local departureMarker = Instance.new("Part")
departureMarker.Name = "RidgeviewDepartureInteraction"
departureMarker.Size = Vector3.new(8, 1, 2)
departureMarker.CFrame = CFrame.new(0, 1.5, -127)
departureMarker.Anchored = true
departureMarker.Transparency = 1
departureMarker.CanCollide = false
departureMarker.CanTouch = false
departureMarker.Parent = scene

-- Visible waypoint makes the previously invisible departure interaction discoverable.
local waypoint = Instance.new("Part")
waypoint.Name = "RidgeviewDepartureWaypoint"
waypoint.Shape = Enum.PartType.Cylinder
waypoint.Size = Vector3.new(8, 0.8, 0.8)
waypoint.CFrame = departureMarker.CFrame * CFrame.new(0, 4.5, 0) * CFrame.Angles(0, 0, math.rad(90))
waypoint.Anchored = true
waypoint.Material = Enum.Material.Neon
waypoint.Color = Color3.fromRGB(202, 169, 104)
waypoint.Transparency = 0.22
waypoint.CanCollide = false
waypoint.CanTouch = false
waypoint.CanQuery = false
waypoint.CastShadow = false
waypoint.Parent = scene

local waypointLight = Instance.new("PointLight")
waypointLight.Name = "WaypointLight"
waypointLight.Color = waypoint.Color
waypointLight.Brightness = 1.2
waypointLight.Range = 15
waypointLight.Parent = waypoint

local waypointLabel = Instance.new("BillboardGui")
waypointLabel.Name = "RidgeviewWaypointLabel"
waypointLabel.Size = UDim2.fromOffset(180, 42)
waypointLabel.StudsOffset = Vector3.new(0, 5.2, 0)
waypointLabel.MaxDistance = 110
waypointLabel.AlwaysOnTop = false
waypointLabel.Parent = waypoint

local waypointText = Instance.new("TextLabel")
waypointText.Name = "Label"
waypointText.Size = UDim2.fromScale(1, 1)
waypointText.BackgroundTransparency = 1
waypointText.Font = Enum.Font.GothamBold
waypointText.Text = "RIDGEVIEW  •  DEPARTURE"
waypointText.TextColor3 = Color3.fromRGB(245, 224, 177)
waypointText.TextStrokeTransparency = 0.35
waypointText.TextScaled = true
waypointText.Parent = waypointLabel

local departurePrompt = addPrompt(departureMarker, "DepartForRidgeviewPrompt", "Travel", "Ridgeview")
departurePrompt.Triggered:Connect(function(player: Player)
	if player.Character == nil or player:DistanceFromCharacter(departureMarker.Position) > 13 then
		return
	end

	local accepted = MissionService.Advance(player, "report_accessed", "ridgeview_arrival")
	if not accepted then
		return
	end

	local character = player.Character
	if character == nil then
		return
	end
	character:PivotTo(getRidgeviewArrivalCFrame())
	local snapshot = MissionService.GetSnapshot(player)
	if snapshot ~= nil then
		missionStateUpdated:FireClient(player, snapshot)
	end
end)

print("[BTV Roblox] Opening mission interactions ready: sanctuary entry, Scout Report access and gated Ridgeview travel.")
