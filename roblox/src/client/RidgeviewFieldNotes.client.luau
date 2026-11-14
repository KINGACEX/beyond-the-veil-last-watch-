--!strict
-- Responsive presentation for server-recorded Ridgeview observations.
-- The client cannot create or edit field notes.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local remotes = ReplicatedStorage:WaitForChild("BTVRemotes")
local fieldNoteRecorded = remotes:WaitForChild("FieldNoteRecorded") :: RemoteEvent
local getFieldNotes = remotes:WaitForChild("GetFieldNotes") :: RemoteFunction
local missionStateUpdated = remotes:WaitForChild("MissionStateUpdated") :: RemoteEvent
local getMissionState = remotes:WaitForChild("GetMissionState") :: RemoteFunction

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BTVRidgeviewFieldNotes"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 24
screenGui.Parent = playerGui

local toggle = Instance.new("TextButton")
toggle.Name = "FieldNotesToggle"
toggle.AnchorPoint = Vector2.new(1, 0)
toggle.Position = UDim2.new(1, -12, 0, 12)
toggle.Size = UDim2.fromOffset(116, 40)
toggle.BackgroundColor3 = Color3.fromRGB(30, 43, 49)
toggle.Text = "FIELD NOTES  0"
toggle.TextColor3 = Color3.fromRGB(244, 240, 226)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 12
toggle.AutoButtonColor = true
toggle.Parent = screenGui
toggle.Visible = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggle

local panel = Instance.new("Frame")
panel.Name = "FieldNotesPanel"
panel.AnchorPoint = Vector2.new(1, 0)
panel.Position = UDim2.new(1, -12, 0, 60)
panel.Size = UDim2.fromOffset(330, 270)
panel.BackgroundColor3 = Color3.fromRGB(17, 24, 31)
panel.BackgroundTransparency = 0.04
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local heading = Instance.new("TextLabel")
heading.Name = "Heading"
heading.Position = UDim2.fromOffset(14, 10)
heading.Size = UDim2.new(1, -28, 0, 22)
heading.BackgroundTransparency = 1
heading.Text = "RIDGEVIEW  /  FIELD NOTES"
heading.TextColor3 = Color3.fromRGB(204, 177, 119)
heading.Font = Enum.Font.GothamBold
heading.TextSize = 13
heading.TextXAlignment = Enum.TextXAlignment.Left
heading.Parent = panel

local objectiveLabel = Instance.new("TextLabel")
objectiveLabel.Name = "CurrentObjective"
objectiveLabel.Position = UDim2.fromOffset(14, 33)
objectiveLabel.Size = UDim2.new(1, -28, 0, 34)
objectiveLabel.BackgroundTransparency = 1
objectiveLabel.Text = "Current objective: Investigate Ridgeview"
objectiveLabel.TextColor3 = Color3.fromRGB(224, 226, 217)
objectiveLabel.Font = Enum.Font.GothamMedium
objectiveLabel.TextSize = 10
objectiveLabel.TextWrapped = true
objectiveLabel.TextXAlignment = Enum.TextXAlignment.Left
objectiveLabel.TextYAlignment = Enum.TextYAlignment.Top
objectiveLabel.Parent = panel

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "Entries"
scroll.Position = UDim2.fromOffset(10, 72)
scroll.Size = UDim2.new(1, -20, 1, -82)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.fromOffset(0, 0)
scroll.Parent = panel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local function makeLabel(name: string, parent: Instance, text: string, height: number, color: Color3, size: number, bold: boolean)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.new(1, -8, 0, height)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
	label.TextSize = size
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = parent
	return label
end

local function render(entries: { any })
	toggle.Text = "FIELD NOTES  " .. tostring(#entries)

	for _, child in scroll:GetChildren() do
		if child ~= listLayout then
			child:Destroy()
		end
	end

	if #entries == 0 then
		makeLabel(
			"EmptyState",
			scroll,
			"No observations recorded yet. Examine the marked belongings and work vehicle near the Ridgeview approach.",
			48,
			Color3.fromRGB(197, 205, 207),
			12,
			false
		)
		return
	end

	for index, entry in entries do
		local card = Instance.new("Frame")
		card.Name = "FieldNote_" .. tostring(index)
		card.Size = UDim2.new(1, -4, 0, 92)
		card.AutomaticSize = Enum.AutomaticSize.Y
		card.BackgroundColor3 = Color3.fromRGB(35, 46, 53)
		card.BackgroundTransparency = 0.12
		card.LayoutOrder = index
		card.Parent = scroll

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = card

		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, 9)
		padding.PaddingBottom = UDim.new(0, 9)
		padding.PaddingLeft = UDim.new(0, 10)
		padding.PaddingRight = UDim.new(0, 10)
		padding.Parent = card

		local title = makeLabel("Title", card, tostring(entry.Title), 18, Color3.fromRGB(240, 235, 222), 12, true)
		title.Size = UDim2.new(1, 0, 0, 18)

		local confidence = makeLabel("Confidence", card, tostring(entry.Category or "Evidence") .. "  •  " .. tostring(entry.Confidence), 15, Color3.fromRGB(202, 177, 124), 10, true)
		confidence.Position = UDim2.fromOffset(0, 21)
		confidence.Size = UDim2.new(1, 0, 0, 15)

		local body = makeLabel("Observation", card, tostring(entry.Text), 42, Color3.fromRGB(207, 215, 216), 11, false)
		body.Position = UDim2.fromOffset(0, 40)
		body.Size = UDim2.new(1, 0, 0, 42)
	end
end

toggle.Activated:Connect(function()
	panel.Visible = not panel.Visible
end)

local function updateMissionAccess(snapshot: any)
	local unlocked = typeof(snapshot) == "table" and (snapshot.phase == "ridgeview_arrival" or snapshot.phase == "ridgeview_investigation")
	toggle.Visible = unlocked
	if unlocked then
		local objective = if typeof(snapshot.objective) == "string" then snapshot.objective else "Investigate Ridgeview"
		local status = if typeof(snapshot.status) == "string" then snapshot.status else ""
		objectiveLabel.Text = objective .. (if status ~= "" then "\n" .. status else "")
	end
	if not unlocked then
		panel.Visible = false
	end
end

missionStateUpdated.OnClientEvent:Connect(updateMissionAccess)

local function requestInitialNotes()
	local missionOk, missionSnapshot = pcall(function()
		return getMissionState:InvokeServer()
	end)
	if missionOk then
		updateMissionAccess(missionSnapshot)
	end

	local ok, entries = pcall(function()
		return getFieldNotes:InvokeServer()
	end)
	if ok and typeof(entries) == "table" then
		render(entries)
	else
		warn("[BTV Roblox] Field notes could not be loaded from the server.")
	end
end

fieldNoteRecorded.OnClientEvent:Connect(function(entries: any)
	if typeof(entries) == "table" then
		render(entries)
	end
end)

local function resizePanel()
	local camera = workspace.CurrentCamera
	local viewport = if camera ~= nil then camera.ViewportSize else Vector2.new(1280, 720)
	local width = math.clamp(viewport.X - 24, 260, 360)
	local height = math.clamp(viewport.Y * 0.42, 210, 300)
	panel.Size = UDim2.fromOffset(width, height)
	panel.Position = UDim2.new(1, -12, 0, 60)
	toggle.Position = UDim2.new(1, -12, 0, 12)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		toggle.Size = UDim2.fromOffset(126, 42)
	else
		toggle.Size = UDim2.fromOffset(116, 40)
	end
end

resizePanel()
if workspace.CurrentCamera ~= nil then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resizePanel)
end

requestInitialNotes()
