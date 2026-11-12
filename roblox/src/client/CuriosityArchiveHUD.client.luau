--!strict
-- Compact, optional discovery progress indicator for the Curiosity Archive.
-- Hidden until the player finds a Curio Mark; no shop or purchase prompts.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "BTVCuriosityArchiveHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 12
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "CurioProgress"
panel.AnchorPoint = Vector2.new(1, 0)
panel.Position = UDim2.new(1, -14, 0, 14)
panel.Size = UDim2.fromOffset(218, 42)
panel.BackgroundColor3 = Color3.fromRGB(28, 39, 47)
panel.BackgroundTransparency = 0.12
panel.Visible = false
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 9)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(177, 145, 83)
stroke.Thickness = 1
stroke.Transparency = 0.2
stroke.Parent = panel

local label = Instance.new("TextLabel")
label.Name = "ProgressText"
label.Size = UDim2.new(1, -16, 1, 0)
label.Position = UDim2.fromOffset(8, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamMedium
label.TextSize = 12
label.TextColor3 = Color3.fromRGB(244, 238, 221)
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextWrapped = true
label.Parent = panel

local function update()
	local count = player:GetAttribute("BTVCurioMarks")
	local unlocked = player:GetAttribute("BTVArchiveUnlocked")
	if typeof(count) ~= "number" then
		count = 0
	end
	panel.Visible = count > 0 or unlocked == true
	if unlocked == true then
		label.Text = "CURIOSITY ARCHIVE  •  UNLOCKED"
	else
		label.Text = string.format("CURIO MARKS  •  %d / 3", math.clamp(count, 0, 3))
	end
end

player:GetAttributeChangedSignal("BTVCurioMarks"):Connect(update)
player:GetAttributeChangedSignal("BTVArchiveUnlocked"):Connect(update)
update()
