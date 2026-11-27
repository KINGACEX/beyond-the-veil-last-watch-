local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LastWatchHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local title = Instance.new("TextLabel")
title.Name = "Title"
title.AnchorPoint = Vector2.new(0.5, 0)
title.Position = UDim2.fromScale(0.5, 0.045)
title.Size = UDim2.new(0.8, 0, 0, 48)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = config.GameTitle
title.TextColor3 = Color3.fromRGB(245, 232, 198)
title.TextScaled = true
title.Parent = screenGui

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Objective"
subtitle.AnchorPoint = Vector2.new(0.5, 0)
subtitle.Position = UDim2.fromScale(0.5, 0.105)
subtitle.Size = UDim2.new(0.8, 0, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = config.StartingObjective
subtitle.TextColor3 = Color3.fromRGB(224, 224, 224)
subtitle.TextScaled = true
subtitle.Parent = screenGui

player.CharacterAdded:Connect(function()
	-- Keep the custom HUD available after each respawn.
	screenGui.Parent = player:WaitForChild("PlayerGui")
end)

print("Last Watch client HUD ready.")
