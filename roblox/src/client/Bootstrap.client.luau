--!strict
-- Client bootstrap: binds presentation to server-created remotes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteFolder = ReplicatedStorage:WaitForChild("BTVRemotes")
local requestEmberCommand = remoteFolder:WaitForChild("RequestEmberCommand") :: RemoteEvent
local requestCompanionSelection = remoteFolder:WaitForChild("RequestCompanionSelection") :: RemoteEvent
local stateUpdated = remoteFolder:WaitForChild("StateUpdated") :: RemoteEvent
local getInitialState = remoteFolder:WaitForChild("GetInitialState") :: RemoteFunction
local missionStateUpdated = remoteFolder:WaitForChild("MissionStateUpdated") :: RemoteEvent
local getMissionState = remoteFolder:WaitForChild("GetMissionState") :: RemoteFunction

local MobileHUDController = require(script.Parent.Controllers.MobileHUDController)

local ok, initialState = pcall(function()
	return getInitialState:InvokeServer()
end)

if not ok then
	warn("[BTV Roblox] Could not retrieve initial session state.")
	initialState = nil
end

local missionOk, initialMissionState = pcall(function()
	return getMissionState:InvokeServer()
end)
if not missionOk then
	warn("[BTV Roblox] Could not retrieve opening mission state.")
	initialMissionState = nil
end

MobileHUDController.Init({
	RequestEmberCommand = requestEmberCommand,
	RequestCompanionSelection = requestCompanionSelection,
	StateUpdated = stateUpdated,
	MissionStateUpdated = missionStateUpdated,
}, initialState, initialMissionState)
