--!strict
-- Lightweight touch-first HUD. Presentation only; server remains authoritative.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CompanionCatalog = require(ReplicatedStorage:WaitForChild("BTVShared"):WaitForChild("CompanionCatalog"))

local MobileHUDController = {}

type RemoteBundle = {
	RequestEmberCommand: RemoteEvent,
	RequestCompanionSelection: RemoteEvent,
	StateUpdated: RemoteEvent,
	MissionStateUpdated: RemoteEvent,
}

local COMMANDS = {
	"Attack",
	"Protect",
	"Scout",
	"Track",
	"Retrieve",
	"Hold",
	"Regroup",
}

local function makeCorner(parent: Instance, radius: number)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end

function MobileHUDController.Init(remotes: RemoteBundle, initialState: any, initialMissionState: any)
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BTVMobileHUD"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.DisplayOrder = 20
	screenGui.Parent = playerGui

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.AnchorPoint = Vector2.new(0, 0)
	header.Position = UDim2.fromOffset(12, 12)
	header.Size = UDim2.fromOffset(220, 54)
	header.BackgroundColor3 = Color3.fromRGB(17, 23, 31)
	header.BackgroundTransparency = 0.12
	header.Parent = screenGui
	makeCorner(header, 10)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(12, 5)
	title.Size = UDim2.new(1, -24, 0, 23)
	title.Font = Enum.Font.GothamBold
	title.Text = "BEYOND THE VEIL"
	title.TextColor3 = Color3.fromRGB(238, 235, 225)
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.fromOffset(12, 28)
	subtitle.Size = UDim2.new(1, -24, 0, 17)
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = "COVENANT  /  WATCHERS"
	subtitle.TextColor3 = Color3.fromRGB(190, 198, 204)
	subtitle.TextSize = 10
	subtitle.TextXAlignment = Enum.TextXAlignment.Left

	subtitle.Parent = header

	local missionCard = Instance.new("Frame")
	missionCard.Name = "MissionObjectiveCard"
	missionCard.Position = UDim2.fromOffset(12, 74)
	missionCard.Size = UDim2.new(1, -24, 0, 78)
	missionCard.BackgroundColor3 = Color3.fromRGB(17, 23, 31)
	missionCard.BackgroundTransparency = 0.16
	missionCard.Parent = screenGui
	makeCorner(missionCard, 10)

	local missionTitle = Instance.new("TextLabel")
	missionTitle.Name = "MissionTitle"
	missionTitle.BackgroundTransparency = 1
	missionTitle.Position = UDim2.fromOffset(12, 7)
	missionTitle.Size = UDim2.new(1, -104, 0, 17)
	missionTitle.Font = Enum.Font.GothamBold
	missionTitle.Text = "OPENING SEQUENCE  •  1 / 6"
	missionTitle.TextColor3 = Color3.fromRGB(198, 170, 112)
	missionTitle.TextSize = 11
	missionTitle.TextXAlignment = Enum.TextXAlignment.Left
	missionTitle.Parent = missionCard

	local missionObjective = Instance.new("TextLabel")
	missionObjective.Name = "MissionObjective"
	missionObjective.BackgroundTransparency = 1
	missionObjective.Position = UDim2.fromOffset(12, 25)
	missionObjective.Size = UDim2.new(1, -24, 0, 25)
	missionObjective.Font = Enum.Font.GothamMedium
	missionObjective.Text = "Enter the sanctuary"
	missionObjective.TextColor3 = Color3.fromRGB(244, 242, 234)
	missionObjective.TextSize = 14
	missionObjective.TextWrapped = true
	missionObjective.TextXAlignment = Enum.TextXAlignment.Left
	missionObjective.Parent = missionCard

	local missionStatus = Instance.new("TextLabel")
	missionStatus.Name = "MissionStatus"
	missionStatus.BackgroundTransparency = 1
	missionStatus.Position = UDim2.fromOffset(12, 52)
	missionStatus.Size = UDim2.new(1, -24, 0, 17)
	missionStatus.Font = Enum.Font.Gotham
	missionStatus.Text = "First Sunday • Logos Rhema Temple"
	missionStatus.TextColor3 = Color3.fromRGB(182, 192, 199)
	missionStatus.TextSize = 12
	missionStatus.TextXAlignment = Enum.TextXAlignment.Left
	missionStatus.TextTruncate = Enum.TextTruncate.AtEnd
	missionStatus.Parent = missionCard

	local reportPanel = Instance.new("Frame")
	reportPanel.Name = "ScoutReportPanel"
	reportPanel.AnchorPoint = Vector2.new(0.5, 0.5)
	reportPanel.Position = UDim2.fromScale(0.5, 0.5)
	reportPanel.Size = UDim2.new(1, -40, 0, 210)
	reportPanel.BackgroundColor3 = Color3.fromRGB(16, 23, 31)
	reportPanel.BackgroundTransparency = 0.04
	reportPanel.Visible = false
	reportPanel.ZIndex = 30
	reportPanel.Parent = screenGui
	makeCorner(reportPanel, 14)

	local reportTitle = Instance.new("TextLabel")
	reportTitle.Name = "ReportTitle"
	reportTitle.BackgroundTransparency = 1
	reportTitle.Position = UDim2.fromOffset(16, 14)
	reportTitle.Size = UDim2.new(1, -72, 0, 24)
	reportTitle.Font = Enum.Font.GothamBold
	reportTitle.Text = "SCOUT REPORT"
	reportTitle.TextColor3 = Color3.fromRGB(198, 170, 112)
	reportTitle.TextSize = 16
	reportTitle.TextXAlignment = Enum.TextXAlignment.Left
	reportTitle.ZIndex = 31
	reportTitle.Parent = reportPanel

	local reportClose = Instance.new("TextButton")
	reportClose.Name = "CloseReport"
	reportClose.Position = UDim2.new(1, -48, 0, 10)
	reportClose.Size = UDim2.fromOffset(34, 34)
	reportClose.BackgroundColor3 = Color3.fromRGB(43, 57, 66)
	reportClose.Text = "X"
	reportClose.TextColor3 = Color3.fromRGB(245, 242, 230)
	reportClose.Font = Enum.Font.GothamBold
	reportClose.TextSize = 14
	reportClose.ZIndex = 31
	reportClose.Parent = reportPanel
	makeCorner(reportClose, 8)
	reportClose.Activated:Connect(function()
		reportPanel.Visible = false
	end)

	local reportBody = Instance.new("TextLabel")
	reportBody.Name = "ReportBody"
	reportBody.BackgroundTransparency = 1
	reportBody.Position = UDim2.fromOffset(16, 52)
	reportBody.Size = UDim2.new(1, -32, 1, -68)
	reportBody.Font = Enum.Font.Gotham
	reportBody.Text =
		"MISSION INTELLIGENCE NOT LOADED\n\nNo authored evidence is available in this prototype. Situation, evidence, confidence and recommended response remain unassessed. No mission facts have been fabricated."
	reportBody.TextColor3 = Color3.fromRGB(224, 229, 230)
	reportBody.TextSize = 13
	reportBody.TextWrapped = true
	reportBody.TextXAlignment = Enum.TextXAlignment.Left
	reportBody.TextYAlignment = Enum.TextYAlignment.Top
	reportBody.ZIndex = 31
	reportBody.Parent = reportPanel

	local reportReopen = Instance.new("TextButton")
	reportReopen.Name = "ReopenScoutReport"
	reportReopen.Position = UDim2.new(1, -86, 0, 8)
	reportReopen.Size = UDim2.fromOffset(74, 26)
	reportReopen.BackgroundColor3 = Color3.fromRGB(43, 57, 66)
	reportReopen.Text = "REPORT"
	reportReopen.TextColor3 = Color3.fromRGB(245, 242, 230)
	reportReopen.Font = Enum.Font.GothamBold
	reportReopen.TextSize = 11
	reportReopen.Visible = false
	reportReopen.Parent = missionCard
	makeCorner(reportReopen, 7)
	reportReopen.Activated:Connect(function()
		reportPanel.Visible = true
	end)

	local function updateMission(snapshot: any)
		if typeof(snapshot) ~= "table" then
			return
		end
		local index = if typeof(snapshot.sequenceIndex) == "number" then math.clamp(math.floor(snapshot.sequenceIndex), 1, 6) else 1
		missionTitle.Text = "OPENING SEQUENCE  •  " .. tostring(index) .. " / 4"
		if typeof(snapshot.objective) == "string" then
			missionObjective.Text = snapshot.objective
		end
		if typeof(snapshot.status) == "string" then
			missionStatus.Text = snapshot.status
		end
		if snapshot.phase == "report_accessed" then
			reportPanel.Visible = true
			reportReopen.Visible = true
		elseif snapshot.phase == "ridgeview_arrival" then
			reportPanel.Visible = false
			reportReopen.Visible = true
		end
	end
	updateMission(initialMissionState)

	local toggle = Instance.new("TextButton")
	toggle.Name = "EmberToggle"
	toggle.AnchorPoint = Vector2.new(1, 0)
	toggle.Position = UDim2.new(1, -16, 0, 166)
	toggle.Size = UDim2.fromOffset(112, 46)
	toggle.BackgroundColor3 = Color3.fromRGB(38, 52, 61)
	toggle.TextColor3 = Color3.fromRGB(245, 242, 230)
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 14
	toggle.Text = "EMBER"
	toggle.Parent = screenGui
	makeCorner(toggle, 12)

	local panel = Instance.new("Frame")
	panel.Name = "EmberCommandPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0)
	panel.Position = UDim2.new(0.5, 0, 0, 272)
	panel.Size = UDim2.fromOffset(184, 294)
	panel.BackgroundColor3 = Color3.fromRGB(17, 23, 31)
	panel.BackgroundTransparency = 0.06
	panel.Visible = false
	panel.Parent = screenGui
	makeCorner(panel, 12)

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = panel

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = panel

	local currentCommand = if initialState and typeof(initialState.emberCommand) == "string" then initialState.emberCommand else "Regroup"
	local currentCompanion = if initialState and typeof(initialState.equippedCompanion) == "string" then initialState.equippedCompanion else "ember"

	local function updateToggle()
		toggle.Text = "EMBER: " .. string.upper(currentCommand)
		toggle.Visible = currentCompanion == "ember"
		if not toggle.Visible then
			panel.Visible = false
		end
	end

	for index, command in COMMANDS do
		local button = Instance.new("TextButton")
		button.Name = command .. "Button"
		button.LayoutOrder = index
		button.Size = UDim2.new(1, 0, 0, 34)
		button.BackgroundColor3 = Color3.fromRGB(43, 57, 66)
		button.TextColor3 = Color3.fromRGB(245, 242, 230)
		button.Font = Enum.Font.GothamMedium
		button.TextSize = 13
		button.Text = command
		button.Parent = panel
		makeCorner(button, 8)

		button.Activated:Connect(function()
			if currentCompanion == "ember" then
				remotes.RequestEmberCommand:FireServer(command)
			end
		end)
	end

	toggle.Activated:Connect(function()
		panel.Visible = not panel.Visible
		if panel.Visible then
			companionPanel.Visible = false
		end
	end)

	-- This menu is populated from the server-owned snapshot. The server revalidates every request.
	local companionToggle = Instance.new("TextButton")
	companionToggle.Name = "CompanionToggle"
	companionToggle.AnchorPoint = Vector2.new(1, 0)
	companionToggle.Position = UDim2.new(1, -16, 0, 220)
	companionToggle.Size = UDim2.fromOffset(142, 46)
	companionToggle.BackgroundColor3 = Color3.fromRGB(38, 52, 61)
	companionToggle.TextColor3 = Color3.fromRGB(245, 242, 230)
	companionToggle.Font = Enum.Font.GothamBold
	companionToggle.TextSize = 13
	companionToggle.Parent = screenGui
	makeCorner(companionToggle, 12)

	local companionPanel = Instance.new("Frame")
	companionPanel.Name = "CompanionSelectionPanel"
	companionPanel.AnchorPoint = Vector2.new(0.5, 0)
	companionPanel.Position = UDim2.new(0.5, 0, 0, 272)
	companionPanel.Size = UDim2.fromOffset(184, 214)
	companionPanel.BackgroundColor3 = Color3.fromRGB(17, 23, 31)
	companionPanel.BackgroundTransparency = 0.06
	companionPanel.Visible = false
	companionPanel.Parent = screenGui
	makeCorner(companionPanel, 12)

	local companionLayout = Instance.new("UIListLayout")
	companionLayout.Padding = UDim.new(0, 5)
	companionLayout.SortOrder = Enum.SortOrder.LayoutOrder
	companionLayout.Parent = companionPanel

	local companionPadding = Instance.new("UIPadding")
	companionPadding.PaddingTop = UDim.new(0, 8)
	companionPadding.PaddingBottom = UDim.new(0, 8)
	companionPadding.PaddingLeft = UDim.new(0, 8)
	companionPadding.PaddingRight = UDim.new(0, 8)
	companionPadding.Parent = companionPanel

	local companionButtons: { [string]: TextButton } = {}
	local ownedCompanions = if initialState and typeof(initialState.ownedCompanions) == "table" then initialState.ownedCompanions else {}

	local function displayNameFor(companionId: string): string
		for _, definition in CompanionCatalog do
			if definition.Id == companionId then
				return definition.DisplayName
			end
		end
		return companionId
	end

	local function updateCompanionToggle()
		companionToggle.Text = "COMPANION: " .. string.upper(displayNameFor(currentCompanion))
		for companionId, button in companionButtons do
			button.BackgroundColor3 = if currentCompanion == companionId then Color3.fromRGB(74, 91, 73) else Color3.fromRGB(43, 57, 66)
		end
		updateToggle()
	end

	local order = 0
	for _, definition in CompanionCatalog do
		if ownedCompanions[definition.Id] == true then
			order += 1
			local companionId = definition.Id
			local button = Instance.new("TextButton")
			button.Name = companionId .. "SelectButton"
			button.LayoutOrder = order
			button.Size = UDim2.new(1, 0, 0, 38)
			button.BackgroundColor3 = Color3.fromRGB(43, 57, 66)
			button.TextColor3 = Color3.fromRGB(245, 242, 230)
			button.Font = Enum.Font.GothamMedium
			button.TextSize = 13
			button.Text = definition.DisplayName
			button.Parent = companionPanel
			makeCorner(button, 8)
			companionButtons[companionId] = button
			button.Activated:Connect(function()
				remotes.RequestCompanionSelection:FireServer(companionId)
			end)
		end
	end

	companionToggle.Activated:Connect(function()
		companionPanel.Visible = not companionPanel.Visible
		if companionPanel.Visible then
			panel.Visible = false
		end
	end)

	remotes.MissionStateUpdated.OnClientEvent:Connect(updateMission)

	remotes.StateUpdated.OnClientEvent:Connect(function(snapshot)
		if typeof(snapshot) ~= "table" then
			return
		end
		if typeof(snapshot.emberCommand) == "string" then
			currentCommand = snapshot.emberCommand
			updateToggle()
		end
		if typeof(snapshot.equippedCompanion) == "string" then
			currentCompanion = snapshot.equippedCompanion
			updateCompanionToggle()
		end
	end)

	updateToggle()
	updateCompanionToggle()
end

return MobileHUDController
