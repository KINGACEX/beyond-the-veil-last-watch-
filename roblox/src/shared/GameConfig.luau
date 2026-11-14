--!strict
-- Shared, non-secret BTV Roblox configuration.
-- Canon authority remains in roblox/docs/CANON_ADAPTATION.md and the BTV source-of-truth bibles.

local GameConfig = {
	ProductName = "Beyond the Veil: The Last Watch",
	EditionName = "Roblox Edition",
	FoundationVersion = "0.1",

	-- Persistence remains opt-in until private Studio DataStore validation is approved.
	EnableProfilePersistence = false,
	ProfileDataStoreName = "BTVPlayerProfiles_DEV_001",

	Protagonist = {
		Id = "asher_vance",
		DisplayName = "Asher Vance",
		Age = 18,
		CovenantRank = "Agent/Specialist",
		CovenantBranch = "Watchers",
	},

	EmberCommands = {
		"Attack",
		"Protect",
		"Scout",
		"Track",
		"Retrieve",
		"Hold",
		"Regroup",
	},

	Currencies = {
		Aces = "Aces",
		CovenantCredits = "Covenant Credits",
	},

	OpeningSequence = {
		"First Sunday Communion at Logos Rhema Temple",
		"Covenant alert",
		"Scout Report and evidence review",
		"Journey to Ridgeview",
		"Ridgeview investigation and response",
		"Final report",
	},
}

table.freeze(GameConfig.Protagonist)
table.freeze(GameConfig.EmberCommands)
table.freeze(GameConfig.Currencies)
table.freeze(GameConfig.OpeningSequence)
table.freeze(GameConfig)

return GameConfig
