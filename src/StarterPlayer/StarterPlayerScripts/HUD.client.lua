local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))
local objectiveEvent = ReplicatedStorage:WaitForChild("WatchObjectiveEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LastWatchHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local function makeLabel(name, position, size, font, text, color)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = position
	label.Size = size
	label.BackgroundTransparency = 1
	label.Font = font
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.TextWrapped = true
	label.Parent = screenGui
	return label
end

makeLabel(
	"Title",
	UDim2.fromScale(0.5, 0.045),
	UDim2.new(0.8, 0, 0, 48),
	Enum.Font.GothamBold,
	config.GameTitle,
	Color3.fromRGB(245, 232, 198)
)

makeLabel(
	"Objective",
	UDim2.fromScale(0.5, 0.105),
	UDim2.new(0.8, 0, 0, 32),
	Enum.Font.Gotham,
	config.StartingObjective,
	Color3.fromRGB(224, 224, 224)
)

local status = makeLabel(
	"Status",
	UDim2.fromScale(0.5, 0.16),
	UDim2.new(0.8, 0, 0, 38),
	Enum.Font.GothamMedium,
	"Follow the stone path to the watch bell.",
	Color3.fromRGB(255, 220, 145)
)

objectiveEvent.OnClientEvent:Connect(function(message)
	status.Text = message
end)

player.CharacterAdded:Connect(function()
	screenGui.Parent = player:WaitForChild("PlayerGui")
end)

print("Last Watch client HUD ready.")
