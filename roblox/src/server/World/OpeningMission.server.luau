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

-- A player joining after the world script starts is already initialized by Bootstrap.
-- This listener is only diagnostic; mission state remains owned by MissionService.
Players.PlayerAdded:Connect(function(player: Player)
	task.defer(function()
		if player.Parent == Players then
			local snapshot = MissionService.GetSnapshot(player)
			if snapshot ~= nil then
				missionStateUpdated:FireClient(player, snapshot)
			end
		end
	end)
end)

print("[BTV Roblox] Opening mission interactions ready: sanctuary entry and Scout Report access.")
