--!strict
-- Server-owned Ember visual actor.
-- The current low-poly canine is a replaceable blockout, not the approved final appearance.
-- It uses no external meshes, paid assets, combat stats, detection or mission shortcuts.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerStateService = require(script.Parent.PlayerStateService)
local CompanionRigContract = require(ReplicatedStorage:WaitForChild("BTVShared"):WaitForChild("CompanionRigContract"))

type ActorRecord = {
	model: Model,
	character: Model,
	animationTracks: { [string]: AnimationTrack },
	activeAnimation: string?,
	acknowledgementUntil: number,
}

local CompanionActorService = {}
local actors: { [number]: ActorRecord } = {}
local characterConnections: { [number]: RBXScriptConnection } = {}

local FOLDER_NAME = "BTV_Companions"
local FOLLOW_OFFSET = CFrame.new(-3.2, -1.8, 3.4)
local FOLLOW_RESPONSE = 5.5

local coat = Color3.fromRGB(48, 43, 39)
local coatLight = Color3.fromRGB(83, 66, 53)
local copper = Color3.fromRGB(176, 112, 57)
local eyeColor = Color3.fromRGB(235, 177, 77)
local collarColor = Color3.fromRGB(44, 74, 91)

local function getFolder(): Folder
	local existing = Workspace:FindFirstChild(FOLDER_NAME)
	if existing and existing:IsA("Folder") then
		return existing
	end
	local folder = Instance.new("Folder")
	folder.Name = FOLDER_NAME
	folder.Parent = Workspace
	return folder
end

local function makePart(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3, shape: Enum.PartType?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = CFrame.new(position)
	part.Color = color
	part.Material = Enum.Material.SmoothPlastic
	part.Shape = shape or Enum.PartType.Block
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local assetWarningLogged = false

local function warnInvalidImportedAsset(reason: string)
	if assetWarningLogged then
		return
	end
	assetWarningLogged = true
	warn("[BTV Roblox] Imported Ember rig rejected; using the safe placeholder. " .. reason)
end

local function hasExecutableCode(model: Model): boolean
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
			return true
		end
	end
	return false
end

local function hasDisconnectedMotorParts(model: Model, rootPart: BasePart): boolean
	local connected: { [BasePart]: boolean } = {
		[rootPart] = true,
	}
	local joints: { Motor6D } = {}
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("Motor6D") then
			table.insert(joints, descendant)
		end
	end

	local changed = true
	while changed do
		changed = false
		for _, joint in joints do
			local part0 = joint.Part0
			local part1 = joint.Part1
			if part0 ~= nil and part1 ~= nil then
				if connected[part0] and not connected[part1] then
					connected[part1] = true
					changed = true
				elseif connected[part1] and not connected[part0] then
					connected[part0] = true
					changed = true
				end
			end
		end
	end

	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") and not connected[descendant] then
			return true
		end
	end
	return false
end

local function createImportedEmber(player: Player, character: Model): (Model?, { [string]: AnimationTrack })
	local assetRoot = ServerStorage:FindFirstChild(CompanionRigContract.AssetFolderName)
	if assetRoot == nil then
		return nil, {}
	end

	local companionFolder = assetRoot:FindFirstChild(CompanionRigContract.CompanionFolderName)
	local template = if companionFolder then companionFolder:FindFirstChild(CompanionRigContract.ModelName) else nil
	if template == nil then
		return nil, {}
	end
	if not template:IsA("Model") then
		warnInvalidImportedAsset("The Ember asset entry is not a Model.")
		return nil, {}
	end

	local model = template:Clone()
	local function reject(reason: string): (Model?, { [string]: AnimationTrack })
		model:Destroy()
		warnInvalidImportedAsset(reason)
		return nil, {}
	end

	local rootPart = model.PrimaryPart
	if rootPart == nil or rootPart.Name ~= CompanionRigContract.RootPartName then
		return reject("PrimaryPart must be named " .. CompanionRigContract.RootPartName .. ".")
	end
	if hasExecutableCode(model) then
		return reject("Imported companion assets must not contain Script, LocalScript or ModuleScript descendants.")
	end

	local hasMotorJoints = model:FindFirstChildWhichIsA("Motor6D", true) ~= nil
	local hasBones = model:FindFirstChildWhichIsA("Bone", true) ~= nil
	if not hasMotorJoints and not hasBones then
		return reject("The model contains neither Motor6D joints nor a skinned Bone hierarchy.")
	end
	if hasMotorJoints and hasDisconnectedMotorParts(model, rootPart) then
		return reject("Every BasePart in a Motor6D rig must be connected to CompanionRoot.")
	end

	local controller = model:FindFirstChild(CompanionRigContract.AnimationControllerName, true)
	if controller == nil or not controller:IsA("AnimationController") then
		return reject("AnimationController is missing.")
	end
	local animator = controller:FindFirstChildOfClass("Animator")
	if animator == nil then
		return reject("AnimationController must contain an Animator.")
	end
	local animationFolder = model:FindFirstChild(CompanionRigContract.AnimationFolderName, true)
	if animationFolder == nil or not animationFolder:IsA("Folder") then
		return reject("Animations folder is missing.")
	end

	local animationObjects: { [string]: Animation } = {}
	for _, animationName in CompanionRigContract.RequiredAnimations do
		local animation = animationFolder:FindFirstChild(animationName)
		if animation == nil or not animation:IsA("Animation") then
			return reject("Required animation is missing: " .. animationName .. ".")
		end
		if string.match(animation.AnimationId, "^rbxassetid://%d+$") == nil then
			return reject("Required animation has no valid Roblox asset ID: " .. animationName .. ".")
		end
		animationObjects[animationName] = animation
	end

	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
			descendant.Anchored = descendant == rootPart or not hasMotorJoints
		end
	end

	model.Name = "Ember_" .. player.UserId
	model:SetAttribute("CompanionId", "ember")
	model:SetAttribute("VisualStatus", "IMPORTED RIG PROTOTYPE — NOT FINAL")
	model:SetAttribute("GameplayAdvantage", false)
	model.Parent = getFolder()
	model:PivotTo(character:GetPivot() * FOLLOW_OFFSET)

	local tracks: { [string]: AnimationTrack } = {}
	for _, animationName in CompanionRigContract.RequiredAnimations do
		local animation = animationObjects[animationName]
		local ok, track = pcall(function()
			return animator:LoadAnimation(animation)
		end)
		if not ok or track == nil then
			for _, loadedTrack in tracks do
				loadedTrack:Stop(0)
			end
			return reject("Roblox could not load animation: " .. animationName .. ".")
		end

		local settings = CompanionRigContract.AnimationSettings[animationName]
		track.Looped = settings.Looped
		if settings.Priority == "Idle" then
			track.Priority = Enum.AnimationPriority.Idle
		elseif settings.Priority == "Movement" then
			track.Priority = Enum.AnimationPriority.Movement
		else
			track.Priority = Enum.AnimationPriority.Action
		end
		tracks[animationName] = track
	end

	local idleTrack = tracks.Idle_Breathing
	if idleTrack ~= nil then
		idleTrack:Play(0.2)
	end

	return model, tracks
end

local function createEmber(player: Player, character: Model): Model
	local model = Instance.new("Model")
	model.Name = "Ember_" .. player.UserId
	model:SetAttribute("CompanionId", "ember")
	model:SetAttribute("VisualStatus", "LOW_POLY PLACEHOLDER — final appearance requires approval")
	model:SetAttribute("GameplayAdvantage", false)

	local root = makePart(model, "Root", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0, 2, 0), coat)
	root.Transparency = 1
	model.PrimaryPart = root

	makePart(model, "Body", Vector3.new(1.35, 1.05, 1.95), Vector3.new(0, 2.05, 0.05), coat, Enum.PartType.Ball)
	makePart(model, "Chest", Vector3.new(1.05, 0.9, 0.8), Vector3.new(0, 2.13, -0.68), coatLight, Enum.PartType.Ball)
	makePart(model, "Neck", Vector3.new(0.78, 0.88, 0.72), Vector3.new(0, 2.55, -0.72), coat, Enum.PartType.Ball)
	local head = makePart(model, "Head", Vector3.new(0.92, 0.82, 0.88), Vector3.new(0, 2.95, -1.02), coat, Enum.PartType.Ball)
	makePart(model, "Muzzle", Vector3.new(0.62, 0.38, 0.66), Vector3.new(0, 2.73, -1.58), coatLight, Enum.PartType.Ball)
	makePart(model, "Nose", Vector3.new(0.24, 0.19, 0.2), Vector3.new(0, 2.78, -1.91), Color3.fromRGB(24, 22, 21), Enum.PartType.Ball)

	for _, side in { -1, 1 } do
		makePart(model, "Ear_" .. side, Vector3.new(0.28, 0.52, 0.3), Vector3.new(side * 0.31, 3.48, -0.9), coat, Enum.PartType.Ball)
		makePart(model, "Eye_" .. side, Vector3.new(0.13, 0.13, 0.09), Vector3.new(side * 0.31, 3.02, -1.43), eyeColor, Enum.PartType.Ball)
		makePart(model, "EyePupil_" .. side, Vector3.new(0.055, 0.07, 0.045), Vector3.new(side * 0.31, 3.02, -1.49), Color3.fromRGB(28, 24, 22), Enum.PartType.Ball)
		makePart(model, "FrontLeg_" .. side, Vector3.new(0.3, 0.9, 0.34), Vector3.new(side * 0.43, 1.38, -0.55), coat, Enum.PartType.Ball)
		makePart(model, "RearLeg_" .. side, Vector3.new(0.38, 0.92, 0.42), Vector3.new(side * 0.43, 1.34, 0.66), coat, Enum.PartType.Ball)
		makePart(model, "FrontPaw_" .. side, Vector3.new(0.38, 0.2, 0.48), Vector3.new(side * 0.43, 0.94, -0.59), coatLight, Enum.PartType.Ball)
		makePart(model, "RearPaw_" .. side, Vector3.new(0.4, 0.2, 0.48), Vector3.new(side * 0.43, 0.91, 0.67), coatLight, Enum.PartType.Ball)
	end

	makePart(model, "TailBase", Vector3.new(0.3, 0.3, 0.42), Vector3.new(0, 2.42, 1.02), coat, Enum.PartType.Ball)
	makePart(model, "TailMid", Vector3.new(0.34, 0.38, 0.55), Vector3.new(0, 2.67, 1.34), coatLight, Enum.PartType.Ball)
	makePart(model, "TailTip", Vector3.new(0.4, 0.42, 0.42), Vector3.new(0, 2.9, 1.59), copper, Enum.PartType.Ball)

	makePart(model, "Collar", Vector3.new(0.88, 0.16, 0.7), Vector3.new(0, 2.59, -0.77), collarColor)
	makePart(model, "ChestMarking", Vector3.new(0.38, 0.53, 0.12), Vector3.new(0, 2.12, -1.05), copper, Enum.PartType.Ball)

	local tag = Instance.new("BillboardGui")
	tag.Name = "CompanionNameplate"
	tag.Size = UDim2.fromOffset(120, 28)
	tag.StudsOffset = Vector3.new(0, 1.15, 0)
	tag.AlwaysOnTop = false
	tag.MaxDistance = 45
	tag.Parent = head

	local label = Instance.new("TextLabel")
	label.Name = "Name"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = "EMBER"
	label.TextColor3 = Color3.fromRGB(255, 224, 177)
	label.TextStrokeTransparency = 0.35
	label.TextScaled = true
	label.Parent = tag

	model.Parent = getFolder()
	model:PivotTo(character:GetPivot() * FOLLOW_OFFSET)
	return model
end


-- Non-Ember free companions currently use distinct low-poly blockout actors.
-- These provide a visible, owned follower until reviewed final rigs and animations exist.
local function createBasicCompanion(player: Player, character: Model, companionId: string): Model
	local model = Instance.new("Model")
	model.Name = string.upper(companionId) .. "_" .. player.UserId
	model:SetAttribute("CompanionId", companionId)
	model:SetAttribute("VisualStatus", "LOW_POLY PLACEHOLDER — final rig and animations pending")
	model:SetAttribute("GameplayAdvantage", false)

	local root = makePart(model, "Root", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0, 2, 0), Color3.new(1, 1, 1))
	root.Transparency = 1
	model.PrimaryPart = root

	local bodyColor = Color3.fromRGB(177, 105, 54)
	local lightColor = Color3.fromRGB(225, 205, 166)
	local darkColor = Color3.fromRGB(64, 53, 43)
	local eyeColorLocal = Color3.fromRGB(35, 31, 27)

	if companionId == "fox" then
		makePart(model, "Body", Vector3.new(1.15, 0.82, 1.55), Vector3.new(0, 2.0, 0.05), bodyColor, Enum.PartType.Ball)
		makePart(model, "Chest", Vector3.new(0.72, 0.7, 0.62), Vector3.new(0, 2.08, -0.58), lightColor, Enum.PartType.Ball)
		makePart(model, "Head", Vector3.new(0.78, 0.72, 0.76), Vector3.new(0, 2.67, -0.86), bodyColor, Enum.PartType.Ball)
		makePart(model, "Muzzle", Vector3.new(0.48, 0.3, 0.5), Vector3.new(0, 2.48, -1.32), lightColor, Enum.PartType.Ball)
		for _, side in {-1, 1} do
			makePart(model, "Ear_" .. side, Vector3.new(0.2, 0.62, 0.22), Vector3.new(side * 0.25, 3.25, -0.82), bodyColor, Enum.PartType.Ball)
			makePart(model, "Eye_" .. side, Vector3.new(0.1, 0.1, 0.08), Vector3.new(side * 0.25, 2.72, -1.22), eyeColorLocal, Enum.PartType.Ball)
			makePart(model, "Leg_" .. side, Vector3.new(0.24, 0.78, 0.27), Vector3.new(side * 0.36, 1.35, -0.45), bodyColor, Enum.PartType.Ball)
			makePart(model, "RearLeg_" .. side, Vector3.new(0.27, 0.78, 0.3), Vector3.new(side * 0.36, 1.32, 0.62), bodyColor, Enum.PartType.Ball)
		end
		makePart(model, "Tail", Vector3.new(0.5, 0.52, 1.0), Vector3.new(0, 2.45, 1.1), lightColor, Enum.PartType.Ball)
	elseif companionId == "owl" then
		bodyColor = Color3.fromRGB(105, 83, 64)
		makePart(model, "Body", Vector3.new(1.2, 1.35, 1.0), Vector3.new(0, 2.1, 0), bodyColor, Enum.PartType.Ball)
		makePart(model, "Head", Vector3.new(1.0, 0.92, 0.9), Vector3.new(0, 3.0, -0.18), bodyColor, Enum.PartType.Ball)
		makePart(model, "Face", Vector3.new(0.78, 0.7, 0.2), Vector3.new(0, 2.98, -0.64), lightColor, Enum.PartType.Ball)
		for _, side in {-1, 1} do
			makePart(model, "Eye_" .. side, Vector3.new(0.22, 0.22, 0.12), Vector3.new(side * 0.2, 3.04, -0.77), Color3.fromRGB(205, 157, 70), Enum.PartType.Ball)
			makePart(model, "Pupil_" .. side, Vector3.new(0.1, 0.1, 0.07), Vector3.new(side * 0.2, 3.04, -0.84), eyeColorLocal, Enum.PartType.Ball)
			makePart(model, "Wing_" .. side, Vector3.new(0.32, 1.0, 0.85), Vector3.new(side * 0.72, 2.15, 0.05), darkColor, Enum.PartType.Ball)
			makePart(model, "Foot_" .. side, Vector3.new(0.18, 0.34, 0.18), Vector3.new(side * 0.22, 1.35, -0.12), Color3.fromRGB(173, 126, 67), Enum.PartType.Ball)
		end
		makePart(model, "Beak", Vector3.new(0.2, 0.25, 0.24), Vector3.new(0, 2.8, -0.82), Color3.fromRGB(185, 132, 61), Enum.PartType.Ball)
	elseif companionId == "horse" then
		bodyColor = Color3.fromRGB(111, 72, 48)
		makePart(model, "Body", Vector3.new(1.45, 1.45, 2.25), Vector3.new(0, 2.15, 0.1), bodyColor, Enum.PartType.Ball)
		makePart(model, "Neck", Vector3.new(0.82, 1.5, 0.82), Vector3.new(0, 2.95, -0.78), bodyColor, Enum.PartType.Ball)
		makePart(model, "Head", Vector3.new(0.72, 1.0, 0.72), Vector3.new(0, 3.62, -1.12), bodyColor, Enum.PartType.Ball)
		makePart(model, "Muzzle", Vector3.new(0.58, 0.38, 0.5), Vector3.new(0, 3.32, -1.55), lightColor, Enum.PartType.Ball)
		makePart(model, "Mane", Vector3.new(0.28, 1.45, 0.32), Vector3.new(0, 3.12, -0.95), darkColor, Enum.PartType.Ball)
		for _, side in {-1, 1} do
			makePart(model, "Ear_" .. side, Vector3.new(0.16, 0.48, 0.18), Vector3.new(side * 0.22, 4.15, -1.12), darkColor, Enum.PartType.Ball)
			makePart(model, "Eye_" .. side, Vector3.new(0.09, 0.1, 0.08), Vector3.new(side * 0.29, 3.72, -1.43), eyeColorLocal, Enum.PartType.Ball)
			for _, frontBack in {-1, 1} do
				makePart(model, "Leg_" .. side .. "_" .. frontBack, Vector3.new(0.24, 1.2, 0.27), Vector3.new(side * 0.48, 1.28, frontBack * 0.7), bodyColor, Enum.PartType.Ball)
			end
		end
		makePart(model, "Tail", Vector3.new(0.28, 1.05, 0.3), Vector3.new(0, 1.95, 1.35), darkColor, Enum.PartType.Ball)
	else
		model:Destroy()
		error("No placeholder actor is defined for companion: " .. companionId)
	end

	local nameplate = Instance.new("BillboardGui")
	nameplate.Name = "CompanionNameplate"
	nameplate.Size = UDim2.fromOffset(120, 26)
	nameplate.StudsOffset = Vector3.new(0, 1.2, 0)
	nameplate.MaxDistance = 45
	nameplate.Parent = model.PrimaryPart

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = string.upper(companionId)
	label.TextColor3 = Color3.fromRGB(255, 238, 204)
	label.TextStrokeTransparency = 0.35
	label.TextScaled = true
	label.Parent = nameplate

	model.Parent = getFolder()
	model:PivotTo(character:GetPivot() * FOLLOW_OFFSET)
	return model
end

local function destroyActor(player: Player)
	local actor = actors[player.UserId]
	if actor ~= nil then
		for _, track in actor.animationTracks do
			track:Stop(0)
		end
		actor.model:Destroy()
		actors[player.UserId] = nil
	end
end

function CompanionActorService.RefreshPlayer(player: Player)
	local character = player.Character
	local snapshot = PlayerStateService.GetSnapshot(player)
	if character == nil or snapshot == nil then
		destroyActor(player)
		return
	end

	local companionId = snapshot.equippedCompanion
	local current = actors[player.UserId]
	if current ~= nil and current.character == character and current.model.Parent ~= nil
		and current.model:GetAttribute("CompanionId") == companionId then
		return
	end

	destroyActor(player)
	local model: Model
	local animationTracks: {[string]: AnimationTrack} = {}
	if companionId == "ember" then
		local importedModel, importedTracks = createImportedEmber(player, character)
		if importedModel == nil then
			model = createEmber(player, character)
		else
			model = importedModel
			animationTracks = importedTracks
		end
	else
		model = createBasicCompanion(player, character, companionId)
	end

	actors[player.UserId] = {
		model = model,
		character = character,
		animationTracks = animationTracks,
		activeAnimation = if animationTracks.Idle_Breathing ~= nil then "Idle_Breathing" else nil,
		acknowledgementUntil = 0,
	}
end

function CompanionActorService.BindPlayer(player: Player)
	local previous = characterConnections[player.UserId]
	if previous ~= nil then
		previous:Disconnect()
	end
	characterConnections[player.UserId] = player.CharacterAdded:Connect(function()
		task.defer(CompanionActorService.RefreshPlayer, player)
	end)
	if player.Character ~= nil then
		task.defer(CompanionActorService.RefreshPlayer, player)
	end
end

function CompanionActorService.RemovePlayer(player: Player)
	local connection = characterConnections[player.UserId]
	if connection ~= nil then
		connection:Disconnect()
		characterConnections[player.UserId] = nil
	end
	destroyActor(player)
end

function CompanionActorService.AcknowledgeCommand(player: Player)
	local actor = actors[player.UserId]
	if actor == nil then
		return
	end
	local track = actor.animationTracks.Alert_Acknowledge
	if track == nil then
		return
	end

	local currentTrack = if actor.activeAnimation then actor.animationTracks[actor.activeAnimation] else nil
	if currentTrack ~= nil then
		currentTrack:Stop(0.08)
	end
	track:Stop(0)
	track:Play(0.1)
	actor.activeAnimation = "Alert_Acknowledge"
	actor.acknowledgementUntil = os.clock() + math.clamp(track.Length, 0.65, 2)
end

-- Bound server-side companion transforms to 15 Hz. This limits replicated CFrame churn
-- while retaining exponential smoothing across variable Heartbeat intervals.
local function updateAnimation(actor: ActorRecord, root: BasePart, now: number)
	if next(actor.animationTracks) == nil then
		return
	end

	local horizontalVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
	local desiredAnimation = if now < actor.acknowledgementUntil then "Alert_Acknowledge" elseif horizontalVelocity.Magnitude > 1.15 then "Walk_Cycle" else "Idle_Breathing"
	if desiredAnimation == actor.activeAnimation then
		return
	end

	local currentTrack = if actor.activeAnimation then actor.animationTracks[actor.activeAnimation] else nil
	if currentTrack ~= nil then
		currentTrack:Stop(0.16)
	end
	local nextTrack = actor.animationTracks[desiredAnimation]
	if nextTrack ~= nil then
		nextTrack:Play(0.16)
		actor.activeAnimation = desiredAnimation
	end
end

local FOLLOW_UPDATE_INTERVAL = 1 / 15
local updateAccumulator = 0

RunService.Heartbeat:Connect(function(deltaTime: number)
	updateAccumulator += deltaTime
	if updateAccumulator < FOLLOW_UPDATE_INTERVAL then
		return
	end

	local elapsed = updateAccumulator
	updateAccumulator = 0
	local now = os.clock()
	local alpha = 1 - math.exp(-FOLLOW_RESPONSE * elapsed)
	for userId, actor in actors do
		local player = Players:GetPlayerByUserId(userId)
		local character = actor.character
		local root = character:FindFirstChild("HumanoidRootPart")
		if player == nil or character.Parent == nil then
			actor.model:Destroy()
			actors[userId] = nil
			continue
		end
		if root == nil or not root:IsA("BasePart") then
			continue
		end

		local idleTime = os.clock()
		local idleOffset = CFrame.new(0, math.sin(idleTime * 4) * 0.035, 0) * CFrame.Angles(0, math.sin(idleTime * 1.8) * 0.025, 0)
		local target = root.CFrame * FOLLOW_OFFSET * idleOffset
		local current = actor.model:GetPivot()
		local nextPivot = current:Lerp(target, alpha)
		actor.model:PivotTo(nextPivot)
		updateAnimation(actor, root, now)

		-- Small procedural tail motion adds life without granting any gameplay function.
		local tailMid = actor.model:FindFirstChild("TailMid")
		local tailTip = actor.model:FindFirstChild("TailTip")
		if tailMid and tailMid:IsA("BasePart") then
			tailMid.CFrame = nextPivot * CFrame.new(0, 0.67, 1.34) * CFrame.Angles(0, math.sin(idleTime * 7) * 0.2, 0)
		end
		if tailTip and tailTip:IsA("BasePart") then
			tailTip.CFrame = nextPivot * CFrame.new(0, 0.9, 1.59) * CFrame.Angles(0, math.sin(idleTime * 7 - 0.35) * 0.28, 0)
		end
	end
end)

return CompanionActorService
