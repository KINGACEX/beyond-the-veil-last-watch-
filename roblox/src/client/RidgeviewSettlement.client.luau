--!strict
-- Responsive touch/desktop dialogue presentation. All dialogue and choices are server-authored.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local remotes = ReplicatedStorage:WaitForChild("BTVRemotes")
local dialogueUpdated = remotes:WaitForChild("RidgeviewDialogueUpdated") :: RemoteEvent
local dialogueAction = remotes:WaitForChild("RidgeviewDialogueAction") :: RemoteEvent

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BTVRidgeviewDialogue"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.DisplayOrder = 40
screenGui.Parent = playerGui

local scale = Instance.new("UIScale")
scale.Name = "ResponsiveScale"
scale.Parent = screenGui

local panel = Instance.new("Frame")
panel.Name = "DialoguePanel"
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.new(0.5, 0, 1, -22)
panel.Size = UDim2.fromOffset(560, 286)
panel.BackgroundColor3 = Color3.fromRGB(17, 25, 32)
panel.BackgroundTransparency = 0.035
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(154, 133, 93)
panelStroke.Transparency = 0.35
panelStroke.Thickness = 1
panelStroke.Parent = panel

local speaker = Instance.new("TextLabel")
speaker.Name = "Speaker"
speaker.Position = UDim2.fromOffset(18, 14)
speaker.Size = UDim2.new(1, -36, 0, 24)
speaker.BackgroundTransparency = 1
speaker.Font = Enum.Font.GothamBold
speaker.Text = "RIDGEVIEW"
speaker.TextColor3 = Color3.fromRGB(206, 177, 117)
speaker.TextSize = 14
speaker.TextXAlignment = Enum.TextXAlignment.Left
speaker.Parent = panel

local body = Instance.new("TextLabel")
body.Name = "DialogueText"
body.Position = UDim2.fromOffset(18, 46)
body.Size = UDim2.new(1, -36, 0, 92)
body.BackgroundTransparency = 1
body.Font = Enum.Font.Gotham
body.Text = ""
body.TextColor3 = Color3.fromRGB(239, 238, 229)
body.TextSize = 15
body.TextWrapped = true
body.TextXAlignment = Enum.TextXAlignment.Left
body.TextYAlignment = Enum.TextYAlignment.Top
body.Parent = panel

local choices = Instance.new("ScrollingFrame")
choices.Name = "Choices"
choices.Position = UDim2.fromOffset(14, 148)
choices.Size = UDim2.new(1, -28, 1, -160)
choices.BackgroundTransparency = 1
choices.BorderSizePixel = 0
choices.ScrollBarThickness = 4
choices.AutomaticCanvasSize = Enum.AutomaticSize.Y
choices.CanvasSize = UDim2.fromOffset(0, 0)
choices.Parent = panel

local choiceLayout = Instance.new("UIListLayout")
choiceLayout.Padding = UDim.new(0, 7)
choiceLayout.SortOrder = Enum.SortOrder.LayoutOrder
choiceLayout.Parent = choices

local function updateScale()
	local camera = Workspace.CurrentCamera
	local viewport = if camera ~= nil then camera.ViewportSize else Vector2.new(1280, 720)
	scale.Scale = math.clamp(math.min(viewport.X / 720, viewport.Y / 560), 0.72, 1)
	panel.Size = UDim2.fromOffset(math.max(280, math.min(viewport.X - 24, 560)), math.max(250, math.min(viewport.Y * 0.46, 330)))
end

updateScale()
if Workspace.CurrentCamera ~= nil then
	Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local function clearChoices()
	for _, child in choices:GetChildren() do
		if child ~= choiceLayout then
			child:Destroy()
		end
	end
end

local function render(payload: any)
	if typeof(payload) ~= "table" or payload.visible ~= true then
		panel.Visible = false
		clearChoices()
		return
	end

	speaker.Text = if typeof(payload.speaker) == "string" then string.upper(payload.speaker) else "RIDGEVIEW"
	body.Text = if typeof(payload.text) == "string" then payload.text else ""
	clearChoices()

	if typeof(payload.choices) == "table" then
		for index, choice in payload.choices do
			if typeof(choice) == "table" and typeof(choice.Label) == "string" and typeof(choice.Action) == "string" then
				local button = Instance.new("TextButton")
				button.Name = "Choice_" .. tostring(index)
				button.Size = UDim2.new(1, -6, 0, 42)
				button.BackgroundColor3 = Color3.fromRGB(42, 57, 64)
				button.Text = choice.Label
				button.TextColor3 = Color3.fromRGB(242, 240, 231)
				button.Font = Enum.Font.GothamMedium
				button.TextSize = 13
				button.TextWrapped = true
				button.AutoButtonColor = true
				button.Parent = choices

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 8)
				corner.Parent = button

				button.Activated:Connect(function()
					for _, child in choices:GetChildren() do
						if child:IsA("TextButton") then
							child.Active = false
							child.AutoButtonColor = false
						end
					end
					dialogueAction:FireServer(choice.Action)
				end)
			end
		end
	end

	panel.Visible = true
end

dialogueUpdated.OnClientEvent:Connect(render)
