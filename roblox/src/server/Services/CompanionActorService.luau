--!strict
-- Server-owned Ember visual actor.
-- The current low-poly canine is a replaceable blockout, not the approved final appearance.
-- It uses no external meshes, paid assets, combat stats, detection or mission shortcuts.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local PlayerStateService = require(script.Parent.PlayerStateService)

type ActorRecord = {
	model: Model,
	character: Model,
}

local CompanionActorService = {}
local actors: {[number]: ActorRecord} = {}
local characterConnections: {[number]: RBXScriptConnection} = {}

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

local function makePart(
	parent: Instance,
	name: string,
	size: Vector3,
	position: Vector3,
	color: Color3,
	shape: Enum.PartType?
): Part
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

	for _, side in {-1, 1} do
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

local function destroyActor(player: Player)
	local actor = actors[player.UserId]
	if actor ~= nil then
		actor.model:Destroy()
		actors[player.UserId] = nil
	end
end

function CompanionActorService.RefreshPlayer(player: Player)
	local character = player.Character
	local snapshot = PlayerStateService.GetSnapshot(player)
	if character == nil or snapshot == nil or snapshot.equippedCompanion ~= "ember" then
		destroyActor(player)
		return
	end

	local current = actors[player.UserId]
	if current ~= nil and current.character == character and current.model.Parent ~= nil then
		return
	end

	destroyActor(player)
	actors[player.UserId] = {
		model = createEmber(player, character),
		character = character,
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

RunService.Heartbeat:Connect(function(deltaTime: number)
	local alpha = math.clamp(deltaTime * FOLLOW_RESPONSE, 0, 1)
	for userId, actor in actors do
		local player = Players:GetPlayerByUserId(userId)
		local character = actor.character
		local root = character:FindFirstChild("HumanoidRootPart")
		if player == nil or character.Parent == nil or root == nil or not root:IsA("BasePart") then
			if player ~= nil then
				destroyActor(player)
			else
				actor.model:Destroy()
				actors[userId] = nil
			end
			continue
		end

		local target = root.CFrame * FOLLOW_OFFSET
		local current = actor.model:GetPivot()
		actor.model:PivotTo(current:Lerp(target, alpha))
	end
end)

return CompanionActorService
