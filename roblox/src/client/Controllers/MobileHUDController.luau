--!strict
-- Lightweight touch-first HUD. Presentation only; server remains authoritative.

local MobileHUDController = {}

type RemoteBundle = {
	RequestEmberCommand: RemoteEvent,
	StateUpdated: RemoteEvent,
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

function MobileHUDController.Init(remotes: RemoteBundle, initialState: any)
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

	local toggle = Instance.new("TextButton")
	toggle.Name = "EmberToggle"
	toggle.AnchorPoint = Vector2.new(1, 1)
	toggle.Position = UDim2.new(1, -16, 1, -18)
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
	panel.AnchorPoint = Vector2.new(1, 1)
	panel.Position = UDim2.new(1, -16, 1, -74)
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

	local currentCommand = if initialState and typeof(initialState.emberCommand) == "string"
		then initialState.emberCommand
		else "Regroup"

	local function updateToggle()
		toggle.Text = "EMBER: " .. string.upper(currentCommand)
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
			remotes.RequestEmberCommand:FireServer(command)
		end)
	end

	toggle.Activated:Connect(function()
		panel.Visible = not panel.Visible
	end)

	remotes.StateUpdated.OnClientEvent:Connect(function(snapshot)
		if typeof(snapshot) == "table" and typeof(snapshot.emberCommand) == "string" then
			currentCommand = snapshot.emberCommand
			updateToggle()
		end
	end)

	updateToggle()
end

return MobileHUDController
