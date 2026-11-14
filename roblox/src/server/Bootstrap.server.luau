--!strict
-- Creates the network boundary and starts server-owned session services.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("BTVShared"):WaitForChild("GameConfig"))
local PlayerStateService = require(script.Parent.Services.PlayerStateService)
local MissionService = require(script.Parent.Services.MissionService)
local CompanionActorService = require(script.Parent.Services.CompanionActorService)
local CurrencyService = require(script.Parent.Services.CurrencyService)
local RidgeviewInvestigationService = require(script.Parent.Services.RidgeviewInvestigationService)
local ProfileSessionService = require(script.Parent.Services.ProfileSessionService)

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

local persistenceEnabled = GameConfig.EnableProfilePersistence == true
local persistenceReady = false
if persistenceEnabled then
	local initialized, initializeError = ProfileSessionService.Initialize()
	persistenceReady = initialized
	if not initialized then
		warn("[BTV Roblox] Profile persistence initialization failed: " .. tostring(initializeError))
	else
		ProfileSessionService.StartAutoSave()
	end
end

local function onPlayerAdded(player: Player)
	local profile = nil
	if persistenceEnabled then
		if not persistenceReady then
			player:Kick("Player data is temporarily unavailable. Please try again later.")
			return
		end
		local loadedProfile, loadError = ProfileSessionService.Acquire(player)
		if loadedProfile == nil then
			warn("[BTV Roblox] Profile load failed for user " .. tostring(player.UserId) .. ": " .. tostring(loadError))
			player:Kick("Your player data could not be loaded safely. Please try again later.")
			return
		end
		profile = loadedProfile
	end

	PlayerStateService.AddPlayer(player, profile)
	MissionService.AddPlayer(player, if profile ~= nil then profile.progression.completedMissionIds else nil)
	local restoredInvestigation = if profile ~= nil
		and table.find(profile.progression.completedMissionIds, "ridgeview_investigation_001") ~= nil
		then profile.investigation.ridgeview
		else nil
	InvestigationService.AddPlayer(player, restoredInvestigation)
	CompanionActorService.BindPlayer(player)
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player: Player)
	if persistenceEnabled then
		local saved, saveError = ProfileSessionService.SaveAndRelease(player)
		if not saved then
			warn("[BTV Roblox] Profile save/release failed for user " .. tostring(player.UserId) .. ": " .. tostring(saveError))
		end
	end
	InvestigationService.RemovePlayer(player)
	PlayerStateService.RemovePlayer(player)
	CurrencyService.RemovePlayer(player)
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
	-- Apply the per-player throttle before inspecting payloads or session eligibility.
	-- Invalid requests must not bypass the rate limit and force unbounded server work.
	local now = os.clock()
	local previous = lastCommandAt[player.UserId] or 0
	if now - previous < REQUEST_INTERVAL_SECONDS then
		return
	end
	lastCommandAt[player.UserId] = now

	if typeof(command) ~= "string" or not allowedCommands[command] then
		return
	end
	local accepted = PlayerStateService.SetEmberCommand(player, command)
	if not accepted then
		return
	end
	CompanionActorService.AcknowledgeCommand(player)
	local snapshot = PlayerStateService.GetSnapshot(player)
	if snapshot ~= nil then
		stateUpdated:FireClient(player, snapshot)
	end
end)

requestCompanionSelection.OnServerEvent:Connect(function(player: Player, companionId: unknown)
	-- Throttle every request, including malformed and unowned selections.
	local now = os.clock()
	local previous = lastCompanionSelectionAt[player.UserId] or 0
	if now - previous < COMPANION_SELECTION_INTERVAL_SECONDS then
		return
	end
	lastCompanionSelectionAt[player.UserId] = now

	local accepted = PlayerStateService.SetEquippedCompanion(player, companionId)
	if not accepted then
		return
	end
	CompanionActorService.RefreshPlayer(player)
	local snapshot = PlayerStateService.GetSnapshot(player)
	if snapshot ~= nil then
		stateUpdated:FireClient(player, snapshot)
	end
end)

game:BindToClose(function()
	if persistenceEnabled then
		for _, player in Players:GetPlayers() do
			local saved, saveError = ProfileSessionService.SaveAndRelease(player)
			if not saved then
				warn("[BTV Roblox] Shutdown profile save failed for user " .. tostring(player.UserId) .. ": " .. tostring(saveError))
			end
		end
	end
end)

print("[BTV Roblox] Server foundation ready. Profile persistence is " .. (if persistenceEnabled then "enabled" else "disabled") .. "; premium entitlements remain disabled.")
