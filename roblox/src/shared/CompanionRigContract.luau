--!strict
-- Import contract for a reviewed Ember rig stored in ServerStorage.
-- The contract describes presentation assets only; it grants no gameplay capability.

local CompanionRigContract = {
	AssetFolderName = "BTVAssets",
	CompanionFolderName = "Companions",
	ModelName = "Ember",
	RootPartName = "CompanionRoot",
	AnimationControllerName = "AnimationController",
	AnimationFolderName = "Animations",
	RequiredAnimations = {
		"Idle_Breathing",
		"Walk_Cycle",
		"Alert_Acknowledge",
	},
	AnimationSettings = {
		Idle_Breathing = {
			Looped = true,
			Priority = "Idle",
		},
		Walk_Cycle = {
			Looped = true,
			Priority = "Movement",
		},
		Alert_Acknowledge = {
			Looped = false,
			Priority = "Action",
		},
	},
}

for _, settings in CompanionRigContract.AnimationSettings do
	table.freeze(settings)
end
table.freeze(CompanionRigContract.RequiredAnimations)
table.freeze(CompanionRigContract.AnimationSettings)

return table.freeze(CompanionRigContract)
