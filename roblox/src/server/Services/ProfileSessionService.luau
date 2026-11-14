--!strict
-- Opt-in server profile orchestration around the existing tested persistence adapter.
-- Disabled by default in GameConfig until private Studio DataStore validation is approved.

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("BTVShared"):WaitForChild("GameConfig"))
local shared = ReplicatedStorage:WaitForChild("BTVShared")
local ProfileSchema = require(shared:WaitForChild("PlayerProfileSchema"))
local RankCatalog = require(shared:WaitForChild("CovenantRankCatalog"))
local CompanionCatalog = require(shared:WaitForChild("CompanionCatalog"))
local InventoryPolicy = require(shared:WaitForChild("InventoryPolicy"))
local ItemCatalog = require(shared:WaitForChild("ItemCatalog"))
local LeasePolicy = require(shared:WaitForChild("ProfileLeasePolicy"))
local RecordPolicy = require(shared:WaitForChild("ProfileRecordPolicy"))
local ProfilePersistenceAdapter = require(script.Parent:WaitForChild("ProfilePersistenceAdapter"))
local PlayerStateService = require(script.Parent:WaitForChild("PlayerStateService"))
local MissionService = require(script.Parent:WaitForChild("MissionService"))
local RidgeviewInvestigationService = require(script.Parent:WaitForChild("RidgeviewInvestigationService"))

local ProfileSessionService = {}

type Session = {
	profile: any,
	ownerToken: string,
	revision: number,
}

local adapter: any = nil
local sessions: { [number]: Session } = {}
local saveLocks: { [number]: boolean } = {}
local closingPlayers: { [number]: boolean } = {}
local autoSaveStarted = false
local AUTO_SAVE_INTERVAL_SECONDS = 60
local LEASE_DURATION_SECONDS = 180

local function cloneValue(value: any): any
	if typeof(value) ~= "table" then
		return value
	end
	local copy = {}
	for key, item in value do
		copy[cloneValue(key)] = cloneValue(item)
	end
	return copy
end

function ProfileSessionService.Initialize(): (boolean, string?)
	if adapter ~= nil then
		return true, nil
	end
	if GameConfig.EnableProfilePersistence ~= true then
		return false, "Profile persistence is disabled by GameConfig."
	end
	local ok, result = pcall(function()
		local store = DataStoreService:GetDataStore(GameConfig.ProfileDataStoreName)
		return ProfilePersistenceAdapter.new({
			Store = store,
			ProfileSchema = ProfileSchema,
			RankCatalog = RankCatalog,
			CompanionCatalog = CompanionCatalog,
			InventoryPolicy = InventoryPolicy,
			ItemCatalog = ItemCatalog,
			LeasePolicy = LeasePolicy,
			RecordPolicy = RecordPolicy,
			Clock = os.time,
			Wait = task.wait,
			GenerateToken = function()
				return HttpService:GenerateGUID(false)
			end,
			Random = math.random,
			MaxAttempts = 3,
			BaseDelaySeconds = 0.5,
			LeaseDurationSeconds = LEASE_DURATION_SECONDS,
		})
	end)
	if not ok then
		return false, tostring(result)
	end
	adapter = result
	return true, nil
end

function ProfileSessionService.Acquire(player: Player): (any?, string?)
	if adapter == nil then
		return nil, "Profile persistence adapter is not initialized."
	end
	local acquired, acquireError = adapter:Acquire(player.UserId)
	if acquired == nil then
		return nil, acquireError
	end
	sessions[player.UserId] = {
		profile = cloneValue(acquired.profile),
		ownerToken = acquired.ownerToken,
		revision = acquired.revision,
	}
	closingPlayers[player.UserId] = nil
	return cloneValue(acquired.profile), nil
end

function ProfileSessionService.ReleaseWithoutSave(player: Player): (boolean, string?)
	local userId = player.UserId
	closingPlayers[userId] = true
	while saveLocks[userId] do
		task.wait(0.05)
	end
	local session = sessions[userId]
	if session == nil or adapter == nil then
		closingPlayers[userId] = nil
		return true, nil
	end
	local released, releaseError = adapter:Release(userId, session.ownerToken)
	sessions[userId] = nil
	closingPlayers[userId] = nil
	return released, releaseError
end

function ProfileSessionService.Save(player: Player, allowClosing: boolean?): (boolean, string?)
	local userId = player.UserId
	if closingPlayers[userId] and allowClosing ~= true then
		return false, "Profile session is closing."
	end
	while saveLocks[userId] do
		task.wait(0.05)
	end
	saveLocks[userId] = true

	local function finish(saved: boolean, reason: string?): (boolean, string?)
		saveLocks[userId] = nil
		return saved, reason
	end

	local session = sessions[userId]
	if session == nil or adapter == nil then
		return finish(false, "No acquired profile session exists.")
	end
	local playerState = PlayerStateService.GetSnapshot(player)
	if playerState == nil then
		return finish(false, "Player state is not ready.")
	end

	local candidate = cloneValue(session.profile)
	candidate.identity.characterId = playerState.characterId
	candidate.identity.covenantBranch = playerState.covenantBranch
	candidate.progression.covenantRank = playerState.covenantRank
	local completedMissionIds = MissionService.GetCompletedMissionIds(player)
	candidate.progression.completedMissionIds = completedMissionIds
	local ridgeviewCompleted = false
	for _, missionId in completedMissionIds do
		if missionId == "ridgeview_investigation_001" then
			ridgeviewCompleted = true
			break
		end
	end
	candidate.investigation.ridgeview = if ridgeviewCompleted
		then RidgeviewInvestigationService.GetPersistentState(player)
		else {
			observations = {},
			wrenTestimonyRecorded = false,
			wrenSharePermission = false,
			pikeAdmissionRecorded = false,
		}
	candidate.economy.aces = playerState.aces
	candidate.economy.covenantCredits = playerState.covenantCredits
	candidate.companions.owned = cloneValue(playerState.ownedCompanions)
	candidate.companions.equipped = playerState.equippedCompanion

	local callOk, saved, saveError = pcall(function()
		return adapter:Save(
			userId,
			session.ownerToken,
			candidate,
			HttpService:GenerateGUID(false)
		)
	end)
	if not callOk then
		return finish(false, tostring(saved))
	end
	if saved == nil then
		return finish(false, saveError)
	end
	session.profile = cloneValue(saved.profile)
	session.revision = saved.revision
	return finish(true, nil)
end
function ProfileSessionService.SaveAndRelease(player: Player): (boolean, string?)
	local userId = player.UserId
	local session = sessions[userId]
	if session == nil or adapter == nil then
		return true, nil
	end
	closingPlayers[userId] = true

	local saved, saveError = ProfileSessionService.Save(player, true)
	if not saved then
		-- Do not release a lease after a failed save; let it expire rather than
		-- inviting another server to load a potentially stale profile immediately.
		sessions[userId] = nil
		closingPlayers[userId] = nil
		return false, saveError
	end

	local released, releaseError = adapter:Release(userId, session.ownerToken)
	sessions[userId] = nil
	closingPlayers[userId] = nil
	if not released then
		return false, releaseError
	end
	return true, nil
end

function ProfileSessionService.StartAutoSave()
	if autoSaveStarted or adapter == nil then
		return
	end
	autoSaveStarted = true
	task.spawn(function()
		while true do
			task.wait(AUTO_SAVE_INTERVAL_SECONDS)
			for _, player in Players:GetPlayers() do
				local saved, saveError = ProfileSessionService.Save(player)
				if not saved then
					warn("[BTV Roblox] Profile autosave failed for user " .. tostring(player.UserId) .. ": " .. tostring(saveError))
				end
			end
		end
	end)
end

return ProfileSessionService
