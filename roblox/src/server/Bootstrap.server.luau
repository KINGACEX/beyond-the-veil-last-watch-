--!strict
-- Creates the network boundary and starts server-owned session services.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("BTVShared"):WaitForChild("GameConfig"))
local PlayerStateService = require(script.Parent.Services.PlayerStateService)
local MissionService = require(script.Parent.Services.MissionService)
local CompanionActorService = require(script.Parent.Services.CompanionActorService)

local REMOTE_FOLDER_NAME = "BTVRemotes"
local remoteFolder = ReplicatedStorage:FindFirstChild(REMOTE_FOLDER_NAME)
if remoteFolder == nil then
	remoteFolder = Instance.new("Folder")
	remoteFolder.Name = REMOTE_FOLDER_NAME
	remoteFolder.Parent = ReplicatedStorage
end

local function getOrCreateRemote(className: string, name: string): Instance
	local existing = remoteFolder:FindFirstChild(name)
	if existing ~= nil then
		assert(existing.ClassName == className, name .. " has an unexpected class.")
		return existing
	end
	local remote = Instance.new(className)
	remote.Name = name
	remote.Parent = remoteFolder
	return remote
end

local requestEmberCommand = getOrCreateRemote("RemoteEvent", "RequestEmberCommand") :: RemoteEvent
local requestCompanionSelection = getOrCreateRemote("RemoteEvent", "RequestCompanionSelection") :: RemoteEvent
local stateUpdated = getOrCreateRemote("RemoteEvent", "StateUpdated") :: RemoteEvent
local getInitialState = getOrCreateRemote("RemoteFunction", "GetInitialState") :: RemoteFunction
getOrCreateRemote("RemoteEvent", "MissionStateUpdated")
local getMissionState = getOrCreateRemote("RemoteFunction", "GetMissionState") :: RemoteFunction

local allowedCommands: { [string]: boolean } = {}
for _, command in GameConfig.EmberCommands do
	allowedCommands[command] = true
end

local lastCommandAt: { [number]: number } = {}
local lastCompanionSelectionAt: { [number]: number } = {}
local REQUEST_INTERVAL_SECONDS = 0.4
local COMPANION_SELECTION_INTERVAL_SECONDS = 0.5

local function onPlayerAdded(player: Player)
	PlayerStateService.AddPlayer(player)
	MissionService.AddPlayer(player)
	CompanionActorService.BindPlayer(player)
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player: Player)
	PlayerStateService.RemovePlayer(player)
	MissionService.RemovePlayer(player)
	CompanionActorService.RemovePlayer(player)
	lastCommandAt[player.UserId] = nil
	lastCompanionSelectionAt[player.UserId] = nil
end)

getInitialState.OnServerInvoke = function(player: Player)
	return PlayerStateService.GetSnapshot(player)
end

getMissionState.OnServerInvoke = function(player: Player)
	return MissionService.GetSnapshot(player)
end

requestEmberCommand.OnServerEvent:Connect(function(player: Player, command: unknown)
	if typeof(command) ~= "string" or not allowedCommands[command] then
		return
	end
	local now = os.clock()
	local previous = lastCommandAt[player.UserId] or 0
	if now - previous < REQUEST_INTERVAL_SECONDS then
		return
	end
	local accepted = PlayerStateService.SetEmberCommand(player, command)
	if not accepted then
		return
	end
	lastCommandAt[player.UserId] = now
	local snapshot = PlayerStateService.GetSnapshot(player)
	if snapshot ~= nil then
		stateUpdated:FireClient(player, snapshot)
	end
end)

requestCompanionSelection.OnServerEvent:Connect(function(player: Player, companionId: unknown)
	local now = os.clock()
	local previous = lastCompanionSelectionAt[player.UserId] or 0
	if now - previous < COMPANION_SELECTION_INTERVAL_SECONDS then
		return
	end
	local accepted = PlayerStateService.SetEquippedCompanion(player, companionId)
	if not accepted then
		return
	end
	lastCompanionSelectionAt[player.UserId] = now
	CompanionActorService.RefreshPlayer(player)
	local snapshot = PlayerStateService.GetSnapshot(player)
	if snapshot ~= nil then
		stateUpdated:FireClient(player, snapshot)
	end
end)

print("[BTV Roblox] Server foundation ready. Companion selection is session-only; persistence and premium entitlements are not enabled.")
