--!strict
-- Client bootstrap: binds presentation to server-created remotes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteFolder = ReplicatedStorage:WaitForChild("BTVRemotes")
local requestEmberCommand = remoteFolder:WaitForChild("RequestEmberCommand") :: RemoteEvent
local stateUpdated = remoteFolder:WaitForChild("StateUpdated") :: RemoteEvent
local getInitialState = remoteFolder:WaitForChild("GetInitialState") :: RemoteFunction

local MobileHUDController = require(script.Parent.Controllers.MobileHUDController)

local ok, initialState = pcall(function()
	return getInitialState:InvokeServer()
end)

if not ok then
	warn("[BTV Roblox] Could not retrieve initial session state.")
	initialState = nil
end

MobileHUDController.Init({
	RequestEmberCommand = requestEmberCommand,
	StateUpdated = stateUpdated,
}, initialState)
