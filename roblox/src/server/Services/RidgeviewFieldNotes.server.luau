--!strict
-- Server-authoritative, session-only Ridgeview approach investigation.
-- Only approved visible observations are recorded; interpretation remains with the player.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local shared = ReplicatedStorage:WaitForChild("BTVShared")
local FieldNoteCatalog = require(shared:WaitForChild("RidgeviewFieldNoteCatalog"))
local FieldNotePolicy = require(shared:WaitForChild("RidgeviewFieldNotePolicy"))
local MissionService = require(script.Parent:WaitForChild("MissionService"))

local remoteFolder = ReplicatedStorage:WaitForChild("BTVRemotes")

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

local fieldNoteRecorded = getOrCreateRemote("RemoteEvent", "FieldNoteRecorded") :: RemoteEvent
local getFieldNotes = getOrCreateRemote("RemoteFunction", "GetFieldNotes") :: RemoteFunction
local missionStateUpdated = getOrCreateRemote("RemoteEvent", "MissionStateUpdated") :: RemoteEvent

local journals: { [number]: FieldNotePolicy.Journal } = {}
local lastRecordAt: { [number]: number } = {}
local RECORD_INTERVAL_SECONDS = 0.35

local function getJournal(player: Player): FieldNotePolicy.Journal
	local journal = journals[player.UserId]
	if journal == nil then
		journal = {}
		journals[player.UserId] = journal
	end
	return journal
end

getFieldNotes.OnServerInvoke = function(player: Player)
	return FieldNotePolicy.Snapshot(getJournal(player), FieldNoteCatalog)
end

local function recordObservation(player: Player, noteId: string, anchor: BasePart)
	if player.Parent ~= Players or player.Character == nil then
		return
	end

	if player:DistanceFromCharacter(anchor.Position) > 14 then
		return
	end

	local mission = MissionService.GetSnapshot(player)
	if mission == nil or (mission.phase ~= "ridgeview_arrival" and mission.phase ~= "ridgeview_investigation") then
		return
	end

	local now = os.clock()
	local previous = lastRecordAt[player.UserId] or 0
	if now - previous < RECORD_INTERVAL_SECONDS then
		return
	end
	lastRecordAt[player.UserId] = now

	local updated, reason = FieldNotePolicy.TryRecord(getJournal(player), noteId, FieldNoteCatalog)
	if updated == nil then
		if reason ~= "Field note already recorded." then
			warn("[BTV Roblox] Field-note request rejected: " .. tostring(reason))
		end
		return
	end

	journals[player.UserId] = updated
	fieldNoteRecorded:FireClient(player, FieldNotePolicy.Snapshot(updated, FieldNoteCatalog))

	if mission.phase == "ridgeview_arrival" then
		local advanced, snapshot = MissionService.Advance(player, "ridgeview_arrival", "ridgeview_investigation")
		if advanced and snapshot ~= nil then
			missionStateUpdated:FireClient(player, snapshot)
		end
	end
end

local world = Workspace:WaitForChild("BTV_World")
local scene = world:WaitForChild("Ridgeview_LandscapeStudy")
local arrivalMarker = scene:WaitForChild("RidgeviewArrivalMarker") :: BasePart

local existingProps = scene:FindFirstChild("RidgeviewFieldInvestigation")
if existingProps == nil then
	local props = Instance.new("Folder")
	props.Name = "RidgeviewFieldInvestigation"
	props.Parent = scene

	local forward = arrivalMarker.CFrame.LookVector
	local right = arrivalMarker.CFrame.RightVector
	local origin = arrivalMarker.Position + forward * 22

	local function makePart(parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material, canCollide: boolean?): Part
		local part = Instance.new("Part")
		part.Name = name
		part.Size = size
		part.CFrame = cframe
		part.Color = color
		part.Material = material
		part.Anchored = true
		part.CanCollide = canCollide ~= false
		part.CanTouch = false
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.Parent = parent
		return part
	end

	local function addExaminePrompt(anchor: BasePart, noteId: string, objectText: string)
		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "ExaminePrompt"
		prompt.ActionText = "Examine"
		prompt.ObjectText = objectText
		prompt.HoldDuration = 0.35
		prompt.MaxActivationDistance = 10
		prompt.RequiresLineOfSight = false
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
		prompt.Parent = anchor
		prompt.Triggered:Connect(function(player: Player)
			recordObservation(player, noteId, anchor)
		end)
	end

	-- A modest, non-graphic prop cluster representing the approved abandoned belongings.
	local belongingsPosition = origin - right * 8
	local belongings = makePart(
		props,
		"ApproachBelongingsAnchor",
		Vector3.new(2.4, 0.7, 1.5),
		CFrame.lookAt(belongingsPosition + Vector3.new(0, 0.55, 0), belongingsPosition + forward),
		Color3.fromRGB(105, 82, 61),
		Enum.Material.Fabric,
		false
	)
	local belongingsStrap =
		makePart(props, "BelongingsStrap", Vector3.new(0.18, 0.76, 1.55), belongings.CFrame * CFrame.new(0.15, 0, 0), Color3.fromRGB(52, 45, 38), Enum.Material.Fabric, false)
	belongingsStrap.CanQuery = false
	addExaminePrompt(belongings, "approach_belongings", "Belongings")

	-- A restrained vehicle blockout with a visible toolkit; no owner or cause is implied.
	local vehiclePosition = origin + right * 9 + forward * 5
	local vehicleFrame = CFrame.lookAt(vehiclePosition, vehiclePosition + forward)
	local vehicleBody = makePart(props, "ParkedWorkVehicleBody", Vector3.new(7, 0.5, 11), vehicleFrame * CFrame.new(0, 0.65, 0), Color3.fromRGB(73, 91, 83), Enum.Material.Metal)
	makePart(props, "ParkedWorkVehicleCab", Vector3.new(5.8, 2.2, 4.2), vehicleFrame * CFrame.new(0, 2.0, -1.4), Color3.fromRGB(91, 112, 106), Enum.Material.Metal, false)
	makePart(props, "VisibleToolkit", Vector3.new(2.1, 0.65, 1.1), vehicleFrame * CFrame.new(0, 1.25, 3.2), Color3.fromRGB(128, 91, 53), Enum.Material.Metal, false)
	for _, side in { -1, 1 } do
		makePart(
			props,
			"VehicleBedRail_" .. side,
			Vector3.new(0.25, 0.8, 4.2),
			vehicleFrame * CFrame.new(side * 3.15, 1.15, 3.15),
			Color3.fromRGB(73, 91, 83),
			Enum.Material.Metal,
			false
		)
	end
	for _, side in { -1, 1 } do
		for _, z in { -3.4, 3.4 } do
			local wheel = makePart(
				props,
				"VehicleWheel_" .. side .. "_" .. z,
				Vector3.new(1.05, 1.05, 0.55),
				vehicleFrame * CFrame.new(side * 3.55, 0.72, z),
				Color3.fromRGB(31, 33, 34),
				Enum.Material.SmoothPlastic,
				false
			)
			wheel.Shape = Enum.PartType.Cylinder
		end
	end
	addExaminePrompt(vehicleBody, "parked_work_vehicle", "Work vehicle and toolkit")
end

Players.PlayerRemoving:Connect(function(player: Player)
	journals[player.UserId] = nil
	lastRecordAt[player.UserId] = nil
end)

print("[BTV Roblox] Ridgeview field investigation ready: two approved observations, session-only journal, no rewards or inferred conclusions.")
