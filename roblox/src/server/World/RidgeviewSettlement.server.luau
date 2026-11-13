--!strict
-- Ridgeview settlement prototype: reusable blockout environment and server-owned NPC dialogue.
-- NPC visuals are temporary anchored blockouts. No final rigs, skeletal animation or audio are implied.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local shared = ReplicatedStorage:WaitForChild("BTVShared")
local SettlementPolicy = require(shared:WaitForChild("RidgeviewSettlementPolicy"))
local MissionService = require(script.Parent.Parent.Services:WaitForChild("MissionService"))

local remoteFolder = ReplicatedStorage:WaitForChild("BTVRemotes")
local function getOrCreateRemote(name: string): RemoteEvent
	local existing = remoteFolder:FindFirstChild(name)
	if existing ~= nil then
		assert(existing:IsA("RemoteEvent"), name .. " has an unexpected class.")
		return existing
	end
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = remoteFolder
	return remote
end

local dialogueUpdated = getOrCreateRemote("RidgeviewDialogueUpdated")
local dialogueAction = getOrCreateRemote("RidgeviewDialogueAction")

local world = Workspace:WaitForChild("BTV_World")
local scene = world:WaitForChild("Ridgeview_LandscapeStudy")
local arrivalMarker = scene:WaitForChild("RidgeviewArrivalMarker") :: BasePart

if scene:FindFirstChild("RidgeviewSettlement") ~= nil then
	warn("[BTV Roblox] Ridgeview settlement already exists; skipping duplicate build.")
	return
end

local settlement = Instance.new("Model")
settlement.Name = "RidgeviewSettlement"
settlement.Parent = scene

local function makePart(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	material: Enum.Material,
	canCollide: boolean?
): Part
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
	part.CastShadow = true
	part.Parent = parent
	return part
end

local center = arrivalMarker.Position
	+ arrivalMarker.CFrame.RightVector * 90
	+ arrivalMarker.CFrame.LookVector * 30
local right = arrivalMarker.CFrame.RightVector
local forward = arrivalMarker.CFrame.LookVector

local ground = makePart(
	settlement,
	"SettlementGround",
	Vector3.new(150, 1, 118),
	CFrame.new(center + Vector3.new(0, -0.15, 0)),
	Color3.fromRGB(91, 111, 78),
	Enum.Material.Grass
)
ground.CanCollide = true

local function makePath(name: string, startPoint: Vector3, endPoint: Vector3, width: number)
	local midpoint = (startPoint + endPoint) / 2 + Vector3.new(0, 0.38, 0)
	local length = (endPoint - startPoint).Magnitude
	makePart(
		settlement,
		name,
		Vector3.new(width, 0.32, length),
		CFrame.lookAt(midpoint, endPoint),
		Color3.fromRGB(148, 137, 112),
		Enum.Material.Ground,
		false
	)
end

makePath("ApproachPath", arrivalMarker.Position + forward * 8, center - forward * 45, 7)
makePart(settlement, "PublicSquare", Vector3.new(42, 0.35, 34), CFrame.new(center + Vector3.new(0, 0.5, 0)), Color3.fromRGB(135, 126, 105), Enum.Material.Cobblestone, false)

local plaster = Color3.fromRGB(190, 179, 151)
local timber = Color3.fromRGB(91, 68, 49)
local roof = Color3.fromRGB(65, 70, 68)
local window = Color3.fromRGB(104, 137, 145)

local function buildHouse(name: string, position: Vector3, yaw: number)
	local house = Instance.new("Model")
	house.Name = name
	house.Parent = settlement
	local baseFrame = CFrame.new(position) * CFrame.Angles(0, yaw, 0)
	makePart(house, "Foundation", Vector3.new(24, 1, 19), baseFrame * CFrame.new(0, 0.5, 0), Color3.fromRGB(89, 87, 78), Enum.Material.Concrete)
	makePart(house, "RearWall", Vector3.new(24, 12, 1), baseFrame * CFrame.new(0, 6.5, 9), plaster, Enum.Material.Concrete)
	makePart(house, "LeftWall", Vector3.new(1, 12, 19), baseFrame * CFrame.new(-11.5, 6.5, 0), plaster, Enum.Material.Concrete)
	makePart(house, "RightWall", Vector3.new(1, 12, 19), baseFrame * CFrame.new(11.5, 6.5, 0), plaster, Enum.Material.Concrete)
	makePart(house, "FrontLeft", Vector3.new(8, 12, 1), baseFrame * CFrame.new(-8, 6.5, -9), plaster, Enum.Material.Concrete)
	makePart(house, "FrontRight", Vector3.new(8, 12, 1), baseFrame * CFrame.new(8, 6.5, -9), plaster, Enum.Material.Concrete)
	makePart(house, "DoorHeader", Vector3.new(8, 2, 1), baseFrame * CFrame.new(0, 11.5, -9), timber, Enum.Material.Wood)
	makePart(house, "Door", Vector3.new(5, 9, 0.5), baseFrame * CFrame.new(0, 4.5, -9.3), timber, Enum.Material.Wood, false)
	makePart(house, "Roof", Vector3.new(27, 2, 22), baseFrame * CFrame.new(0, 13.5, 0), roof, Enum.Material.Slate)
	for _, side in {-1, 1} do
		makePart(house, "Window_" .. side, Vector3.new(0.35, 3.2, 4.5), baseFrame * CFrame.new(side * 11.1, 7.5, -1), window, Enum.Material.Glass, false)
	end
	return house
end

buildHouse("SettlementHouse_A", center + right * -47 + forward * 34, math.rad(8))
buildHouse("SettlementHouse_B", center + right * 47 + forward * 34, math.rad(-8))
buildHouse("SettlementHouse_C", center + right * -47 - forward * 34, math.rad(178))
buildHouse("SettlementHouse_D", center + right * 47 - forward * 34, math.rad(188))

local sign = makePart(settlement, "RidgeviewOutpostSign", Vector3.new(20, 5, 0.7), CFrame.lookAt(center + forward * 59 + Vector3.new(0, 4, 0), center + forward * 59 + forward), Color3.fromRGB(35, 48, 52), Enum.Material.Slate, false)
local signGui = Instance.new("SurfaceGui")
signGui.Face = Enum.NormalId.Front
signGui.PixelsPerStud = 36
signGui.Parent = sign
local signText = Instance.new("TextLabel")
signText.Size = UDim2.fromScale(1, 1)
signText.BackgroundTransparency = 1
signText.Text = "RIDGEVIEW OUTPOST"
signText.TextColor3 = Color3.fromRGB(238, 230, 207)
signText.Font = Enum.Font.GothamBold
signText.TextScaled = true
signText.Parent = signGui

for index, offset in {
	center + right * -24 + forward * 10,
	center + right * 24 + forward * 10,
	center + right * -24 - forward * 10,
	center + right * 24 - forward * 10,
} do
	local lamp = makePart(settlement, "SettlementLamp_" .. tostring(index), Vector3.new(0.5, 7, 0.5), CFrame.new(offset + Vector3.new(0, 3.5, 0)), timber, Enum.Material.Wood, false)
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 207, 137)
	light.Range = 18
	light.Brightness = 0.65
	light.Shadows = false
	light.Parent = lamp
end

type DialogueLine = { Speaker: string, Text: string }
type Choice = { Label: string, Action: string }
type PlayerConversation = {
	activeNpcId: string?,
	phase: string?,
	step: number,
	policy: SettlementPolicy.State,
	lastActionAt: number,
}

local conversations: { [number]: PlayerConversation } = {}
local npcModels: { [string]: Model } = {}

local function makeNpcPart(model: Model, name: string, size: Vector3, offset: CFrame, color: Color3, shape: Enum.PartType?)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = offset
	part.Color = color
	part.Material = Enum.Material.SmoothPlastic
	part.Shape = shape or Enum.PartType.Block
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = true
	part.Parent = model
	return part
end

local function createNpc(npcId: string, displayName: string, position: Vector3, palette: { Color3 }): Model
	local model = Instance.new("Model")
	model.Name = npcId
	model:SetAttribute("DisplayName", displayName)
	model:SetAttribute("Role", "Adult NPC blockout")
	model.Parent = settlement
	local root = makeNpcPart(model, "HumanoidRootPart", Vector3.new(1.5, 3.4, 1.1), CFrame.new(position + Vector3.new(0, 2.8, 0)), palette[1])
	model.PrimaryPart = root
	root.Transparency = 1
	makeNpcPart(model, "Torso", Vector3.new(2.1, 2.6, 1.1), root.CFrame, palette[1])
	makeNpcPart(model, "Head", Vector3.new(1.25, 1.25, 1.25), root.CFrame * CFrame.new(0, 2.2, 0), palette[2], Enum.PartType.Ball)
	makeNpcPart(model, "LeftArm", Vector3.new(0.55, 2.2, 0.65), root.CFrame * CFrame.new(-1.3, 0, 0), palette[2])
	makeNpcPart(model, "RightArm", Vector3.new(0.55, 2.2, 0.65), root.CFrame * CFrame.new(1.3, 0, 0), palette[2])
	makeNpcPart(model, "LeftLeg", Vector3.new(0.7, 2.2, 0.75), root.CFrame * CFrame.new(-0.45, -2, 0), palette[3])
	makeNpcPart(model, "RightLeg", Vector3.new(0.7, 2.2, 0.75), root.CFrame * CFrame.new(0.45, -2, 0), palette[3])
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "TalkPrompt"
	prompt.ActionText = "Talk"
	prompt.ObjectText = displayName
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 11
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
	prompt.Parent = model:FindFirstChild("Head") :: BasePart
	npcModels[npcId] = model
	return model
end

local wren = createNpc("Wren", "Wren", center + right * -12 + forward * -7, {
	Color3.fromRGB(87, 109, 116), Color3.fromRGB(178, 145, 116), Color3.fromRGB(53, 57, 58),
})
local pike = createNpc("DorianPike", "Dorian Pike", center + right * 10 + forward * 6, {
	Color3.fromRGB(76, 85, 73), Color3.fromRGB(166, 132, 103), Color3.fromRGB(62, 60, 54),
})
local residentA = createNpc("ResidentA", "Resident", center + right * -35 + forward * 2, {
	Color3.fromRGB(103, 92, 77), Color3.fromRGB(179, 145, 112), Color3.fromRGB(58, 59, 55),
})
local residentB = createNpc("ResidentB", "Resident", center + right * 34 + forward * -3, {
	Color3.fromRGB(70, 91, 103), Color3.fromRGB(170, 136, 109), Color3.fromRGB(63, 59, 52),
})

local function moveBetween(model: Model, first: Vector3, second: Vector3, pause: number)
	task.spawn(function()
		local destination = second
		while model.Parent ~= nil do
			local current = model:GetPivot()
			local target = CFrame.lookAt(destination + Vector3.new(0, 2.8, 0), destination + Vector3.new(0, 2.8, 0) + forward)
			local duration = math.max(2, (target.Position - current.Position).Magnitude / 2.2)
			local started = os.clock()
			while model.Parent ~= nil do
				local alpha = math.clamp((os.clock() - started) / duration, 0, 1)
				model:PivotTo(current:Lerp(target, alpha))
				if alpha >= 1 then
					break
				end
				task.wait(0.05)
			end
			task.wait(pause)
			destination = if destination == first then second else first
		end
	end)
end

moveBetween(residentA, center + right * -35 + forward * 2, center + right * -20 + forward * 20, 1.5)
moveBetween(residentB, center + right * 34 - forward * 3, center + right * 23 - forward * 20, 2.2)
moveBetween(wren, center + right * -12 - forward * 7, center + right * -17 + forward * 4, 4)
moveBetween(pike, center + right * 10 + forward * 6, center + right * 15 + forward * 12, 5)

local function addPlayer(player: Player)
	conversations[player.UserId] = {
		activeNpcId = nil,
		phase = nil,
		step = 0,
		policy = SettlementPolicy.NewState(),
		lastActionAt = 0,
	}
end

local function removePlayer(player: Player)
	conversations[player.UserId] = nil
end

for _, player in Players:GetPlayers() do
	addPlayer(player)
end
Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(removePlayer)

local function send(player: Player, speaker: string, text: string, choices: { Choice })
	dialogueUpdated:FireClient(player, {
		visible = true,
		speaker = speaker,
		text = text,
		choices = choices,
	})
end

local function closeDialogue(player: Player)
	local state = conversations[player.UserId]
	if state ~= nil then
		state.activeNpcId = nil
		state.phase = nil
		state.step = 0
	end
	dialogueUpdated:FireClient(player, { visible = false })
end

local function canInteract(player: Player, npcId: string): boolean
	local model = npcModels[npcId]
	if model == nil or model.PrimaryPart == nil or player.Character == nil then
		return false
	end
	if player:DistanceFromCharacter(model.PrimaryPart.Position) > 14 then
		return false
	end
	local mission = MissionService.GetSnapshot(player)
	return mission ~= nil and mission.phase == "ridgeview_arrival"
end

local function startConversation(player: Player, npcId: string)
	local state = conversations[player.UserId]
	if state == nil or not canInteract(player, npcId) then
		return
	end
	state.activeNpcId = npcId
	state.step = 1

	if npcId == "Wren" then
		if state.policy.wrenTestimonyRecorded and not state.policy.wrenTestimonyShareable then
			state.phase = "wren_permission"
			send(player, "Wren", "You may ask whether I am comfortable with you sharing my recorded account. I can still keep it private.", {
				{ Label = "Ask for permission to share with Pike", Action = "AskWrenPermission" },
				{ Label = "Keep it private", Action = "KeepPrivate" },
				{ Label = "End conversation", Action = "Close" },
			})
			return
		end
		if state.policy.wrenTestimonyRecorded and state.policy.wrenTestimonyShareable then
			state.phase = "wren_recorded"
			send(player, "Wren", "My account is recorded. I have authorized you to share only that I saw the repairman go toward the camp.", {
				{ Label = "End conversation", Action = "Close" },
			})
			return
		end
		state.phase = "wren_intro"
		send(player, "Wren", "Could I speak with you somewhere quieter?", {
			{ Label = "Continue", Action = "Continue" },
			{ Label = "End conversation", Action = "Close" },
		})
		return
	end

	if npcId == "DorianPike" then
		state.phase = "pike_intro"
		send(player, "Dorian Pike", "You came a long way to ask questions. I hope the road wasn't too difficult.", {
			{ Label = "Continue", Action = "Continue" },
			{ Label = "End conversation", Action = "Close" },
		})
		return
	end

	state.phase = "resident"
	local residentLine = if npcId == "ResidentA"
		then "I used to know when the supply vehicle would arrive. Lately, nobody gives a straight answer. I can tell you when I last saw it, but not why it stopped."
		else "The radio cuts in and out. Once I heard someone answer, but I couldn't make out who it was. I won't pretend I know."
	send(player, "Resident", residentLine, {
		{ Label = "End conversation", Action = "Close" },
	})
end

local wrenIntro: { DialogueLine } = {
	{ Speaker = "Asher", Text = "Yes. We can take our time." },
	{ Speaker = "Wren", Text = "Not here. People notice who asks what." },
	{ Speaker = "Asher", Text = "Are you in immediate danger?" },
	{ Speaker = "Wren", Text = "I don't know. I just don't want to stay." },
}
local wrenTestimony: { DialogueLine } = {
	{ Speaker = "Asher", Text = "Tell me what you saw. Start with what you know for certain." },
	{ Speaker = "Wren", Text = "I saw the repairman go toward the camp. I didn't follow him." },
	{ Speaker = "Asher", Text = "When?" },
	{ Speaker = "Wren", Text = "After he argued about the records. I can't give you the exact time." },
	{ Speaker = "Asher", Text = "Did you see him come back?" },
	{ Speaker = "Wren", Text = "No." },
	{ Speaker = "Asher", Text = "Do you know what happened to him?" },
	{ Speaker = "Wren", Text = "No. That's what scares me." },
}
local pikeIntro: { DialogueLine } = {
	{ Speaker = "Asher", Text = "I'm checking on the outpost. The road has been quiet." },
	{ Speaker = "Dorian Pike", Text = "It has. Deliveries have been irregular. People have adjusted." },
	{ Speaker = "Asher", Text = "There are still people here." },
	{ Speaker = "Dorian Pike", Text = "Of course. We haven't vanished. We keep to our routines where we can." },
	{ Speaker = "Asher", Text = "The report says a delivery was missed." },
	{ Speaker = "Dorian Pike", Text = "It was. The road has not been reliable. We have managed what we can." },
	{ Speaker = "Asher", Text = "A repair worker was expected. Do you know where he is?" },
	{ Speaker = "Dorian Pike", Text = "He came to look at the equipment. I can't tell you where he went after that." },
	{ Speaker = "Asher", Text = "I'll look around before I draw conclusions." },
	{ Speaker = "Dorian Pike", Text = "That's sensible. Just don't mistake every rumour for a fact." },
}
local pikeWrenChallenge: { DialogueLine } = {
	{ Speaker = "Dorian Pike", Text = "Wren is frightened. She has had a difficult time." },
	{ Speaker = "Asher", Text = "That doesn't make everything she says false." },
	{ Speaker = "Dorian Pike", Text = "I didn't say it did." },
	{ Speaker = "Asher", Text = "Then answer the part you can answer. Why are people being kept away from the camp?" },
	{ Speaker = "Dorian Pike", Text = "Because I thought it was safer if fewer people went there." },
	{ Speaker = "Asher", Text = "Safer for whom?" },
	{ Speaker = "Dorian Pike", Text = "I don't have a good answer." },
}

local function onAction(player: Player, action: unknown)
	local state = conversations[player.UserId]
	if state == nil or typeof(action) ~= "string" then
		return
	end
	local now = os.clock()
	if now - state.lastActionAt < 0.25 then
		return
	end
	state.lastActionAt = now
	local npcId = state.activeNpcId
	if npcId == nil or not canInteract(player, npcId) then
		closeDialogue(player)
		return
	end

	if action == "Close" then
		closeDialogue(player)
		return
	end

	if state.phase == "wren_intro" and action == "Continue" then
		if state.step <= #wrenIntro then
			local line = wrenIntro[state.step]
			state.step += 1
			send(player, line.Speaker, line.Text, {
				{ Label = "Continue", Action = "Continue" },
				{ Label = "End conversation", Action = "Close" },
			})
		else
			state.phase = "wren_testimony"
			state.step = 1
			local line = wrenTestimony[1]
			send(player, line.Speaker, line.Text, {
				{ Label = "Continue", Action = "Continue" },
				{ Label = "End conversation", Action = "Close" },
			})
		end
		return
	end

	if state.phase == "wren_testimony" and action == "Continue" then
		local nextLine = wrenTestimony[state.step + 1]
		if nextLine ~= nil then
			state.step += 1
			send(player, nextLine.Speaker, nextLine.Text, {
				{ Label = "Continue", Action = "Continue" },
				{ Label = "End conversation", Action = "Close" },
			})
		else
			state.phase = "wren_consent"
			send(player, "Wren", "Would you like to ask my permission to share this specific observation with Pike, or keep it private?", {
				{ Label = "Ask Wren for permission", Action = "AskWrenPermission" },
				{ Label = "Keep this testimony private", Action = "KeepPrivate" },
			})
		end
		return
	end

	if (state.phase == "wren_consent" or state.phase == "wren_permission" or state.phase == "wren_permission_pending") and action == "KeepPrivate" then
		state.policy = SettlementPolicy.RecordWrenTestimony(state.policy)
		local updated = SettlementPolicy.SetWrenSharePermission(state.policy, false)
		if updated ~= nil then
			state.policy = updated
		end
		state.phase = "wren_recorded"
		send(player, "Journal", "Wren's testimony is recorded for this session and remains private. Pike cannot be told about it.", {
			{ Label = "End conversation", Action = "Close" },
		})
		return
	end

	if (state.phase == "wren_consent" or state.phase == "wren_permission") and action == "AskWrenPermission" then
		state.phase = "wren_permission_pending"
		send(player, "Wren", "You may tell Pike only that I saw the repairman go toward the camp. Please don't share anything else.", {
			{ Label = "Confirm Wren's permission", Action = "ConfirmShare" },
			{ Label = "Keep this testimony private", Action = "KeepPrivate" },
		})
		return
	end

	if state.phase == "wren_permission_pending" and action == "ConfirmShare" then
		state.policy = SettlementPolicy.RecordWrenTestimony(state.policy)
		local updated = SettlementPolicy.SetWrenSharePermission(state.policy, true)
		if updated == nil then
			return
		end
		state.policy = updated
		state.phase = "wren_recorded"
		send(player, "Journal", "Wren's testimony is recorded. She explicitly authorized sharing only the observation that she saw the repairman go toward the camp.", {
			{ Label = "End conversation", Action = "Close" },
		})
		return
	end

	if state.phase == "pike_intro" and action == "Continue" then
		local line = pikeIntro[state.step]
		if line ~= nil then
			state.step += 1
			send(player, line.Speaker, line.Text, {
				{ Label = "Continue", Action = "Continue" },
				{ Label = "End conversation", Action = "Close" },
			})
		else
			state.phase = "pike_after_intro"
			local choices: { Choice } = {}
			if SettlementPolicy.CanDiscussWrenWithPike(state.policy) then
				table.insert(choices, { Label = "Discuss Wren's authorized account", Action = "DiscussWren" })
			end
			table.insert(choices, { Label = "End conversation", Action = "Close" })
			send(player, "Dorian Pike", "What else do you need to ask?", choices)
		end
		return
	end

	if state.phase == "pike_after_intro" and action == "DiscussWren" then
		if not SettlementPolicy.CanDiscussWrenWithPike(state.policy) then
			return
		end
		state.phase = "pike_wren_challenge"
		state.step = 1
		local line = pikeWrenChallenge[1]
		send(player, line.Speaker, line.Text, {
			{ Label = "Continue", Action = "Continue" },
			{ Label = "End conversation", Action = "Close" },
		})
		return
	end

	if state.phase == "pike_wren_challenge" and action == "Continue" then
		local nextLine = pikeWrenChallenge[state.step + 1]
		if nextLine ~= nil then
			state.step += 1
			send(player, nextLine.Speaker, nextLine.Text, {
				{ Label = "Continue", Action = "Continue" },
				{ Label = "End conversation", Action = "Close" },
			})
		else
			state.policy = SettlementPolicy.RecordPikeAdmission(state.policy)
			state.phase = "pike_admission_recorded"
			send(player, "Journal", "Pike's limited admission is recorded for this session. It does not establish every accusation or a legal finding.", {
				{ Label = "End conversation", Action = "Close" },
			})
		end
		return
	end
end

for npcId, model in npcModels do
	local prompt = model:FindFirstChild("TalkPrompt", true) :: ProximityPrompt
	prompt.Triggered:Connect(function(player: Player)
		startConversation(player, npcId)
	end)
end

dialogueAction.OnServerEvent:Connect(onAction)

print("[BTV Roblox] Ridgeview settlement blockout and consent-gated NPC conversations initialized.")
