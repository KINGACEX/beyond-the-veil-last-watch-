local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	print(string.format("%s joined Beyond the Veil: Last Watch", player.Name))
end)

print("Beyond the Veil: Last Watch server systems ready.")
