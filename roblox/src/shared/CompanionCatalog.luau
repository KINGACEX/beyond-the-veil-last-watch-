--!strict
-- Data-only companion roster for the BTV Roblox edition.
-- This catalog defines presentation and bounded support identities, not combat stats.
-- Server code must validate ownership and mission context before equipping or issuing commands.
-- No Robux product IDs or prices are defined here.

export type CompanionDefinition = {
	Id: string,
	DisplayName: string,
	Role: string,
	Access: "Core" | "Free" | "PremiumCandidate",
	FreeEquivalent: string?,
	SignatureAbility: string,
	AbilityDescription: string,
	Personality: {string},
	PremiumOffer: string?,
	CoreCommands: {string}?,
}

local CompanionCatalog: {[string]: CompanionDefinition} = {
	Ember = {
		Id = "ember",
		DisplayName = "Ember",
		Role = "Versatile field partner",
		Access = "Core",
		FreeEquivalent = nil,
		SignatureAbility = "Field Bond",
		AbilityDescription = "A reliable all-round partner with clear command acknowledgement, natural follow behaviour and expressive bonding interactions. The seven core commands remain available without a purchase.",
		Personality = {"Loyal", "Alert", "Steady", "Responsive"},
		PremiumOffer = "Ember Bond Pack",
		CoreCommands = {"Attack", "Protect", "Scout", "Track", "Retrieve", "Hold", "Regroup"},
	},
	Eagle = {
		Id = "eagle",
		DisplayName = "Eagle",
		Role = "Long-range environmental observation",
		Access = "PremiumCandidate",
		FreeEquivalent = "Owl",
		SignatureAbility = "High Perch",
		AbilityDescription = "Performs a broad, visible-environment observation from a valid perch. It never reveals hidden evidence, objectives or entities through cover.",
		Personality = {"Composed", "Independent", "Watchful"},
	},
	Fox = {
		Id = "fox",
		DisplayName = "Fox",
		Role = "Agile ground exploration",
		Access = "Free",
		FreeEquivalent = nil,
		SignatureAbility = "Curious Approach",
		AbilityDescription = "Approaches ordinary nearby environmental interaction points and signals that an interaction may be available. It does not identify mission clues or solve objectives.",
		Personality = {"Curious", "Quick", "Cautious"},
	},
	Bear = {
		Id = "bear",
		DisplayName = "Bear",
		Role = "Protective positioning",
		Access = "PremiumCandidate",
		FreeEquivalent = "Ember",
		SignatureAbility = "Steady Guard",
		AbilityDescription = "Uses a distinct, grounded protective stance and formation animation. It grants no extra health, armour, damage, threat or crowd-control effect.",
		Personality = {"Calm", "Patient", "Dependable"},
	},
	Owl = {
		Id = "owl",
		DisplayName = "Owl",
		Role = "Quiet environmental observation",
		Access = "Free",
		FreeEquivalent = nil,
		SignatureAbility = "Quiet Watch",
		AbilityDescription = "Provides the same broad observation category as Eagle and Falcon, expressed through perching and calm visual feedback. No hidden evidence or secret-object detection.",
		Personality = {"Patient", "Observant", "Deliberate"},
	},
	Leopard = {
		Id = "leopard",
		DisplayName = "Leopard",
		Role = "Agile route-following support",
		Access = "PremiumCandidate",
		FreeEquivalent = "Fox",
		SignatureAbility = "Path Rhythm",
		AbilityDescription = "Uses a distinct movement style while following valid, accessible routes. It does not unlock shortcuts or increase player movement statistics.",
		Personality = {"Focused", "Reserved", "Confident"},
	},
	Horse = {
		Id = "horse",
		DisplayName = "Horse",
		Role = "Travel companion",
		Access = "Free",
		FreeEquivalent = nil,
		SignatureAbility = "Trail Companion",
		AbilityDescription = "Provides a steady travel-follow experience. Mounted travel is a separate feature and must not be advertised until locomotion, camera, collision and multiplayer tests pass.",
		Personality = {"Steady", "Social", "Dependable"},
	},
	Falcon = {
		Id = "falcon",
		DisplayName = "Falcon",
		Role = "Responsive aerial observation",
		Access = "PremiumCandidate",
		FreeEquivalent = "Owl",
		SignatureAbility = "Swift Perch",
		AbilityDescription = "Presents the shared broad-observation role with quicker flight and return animations. It grants no additional detection range or mission information.",
		Personality = {"Alert", "Energetic", "Disciplined"},
	},
}

for _, definition in CompanionCatalog do
	table.freeze(definition.Personality)
	if definition.CoreCommands ~= nil then
		table.freeze(definition.CoreCommands)
	end
	table.freeze(definition)
end

return table.freeze(CompanionCatalog)
