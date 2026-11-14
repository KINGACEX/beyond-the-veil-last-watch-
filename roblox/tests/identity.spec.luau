--!strict
-- Offline regression checks for the locked player identity rule.
-- Run from the roblox directory with: lune run tests/identity.spec.luau
--
-- Asher Vance remains the sole Chosen. Every other connected player is an
-- individual Covenant operative. These checks prove that no stored profile, no
-- session and no migration can carry the protagonist's identity or the Chosen
-- role, and that a profile stored before the rule still migrates forward
-- without losing the player's data.

local PlayerIdentityPolicy = require("../src/shared/PlayerIdentityPolicy")
local PlayerProfileSchema = require("../src/shared/PlayerProfileSchema")
local CovenantRankCatalog = require("../src/shared/CovenantRankCatalog")
local CompanionCatalog = require("../src/shared/CompanionCatalog")
local InventoryPolicy = require("../src/shared/InventoryPolicy")
local ItemCatalog = require("../src/shared/ItemCatalog")

local function expect(condition: boolean, message: string)
	if not condition then
		error("[BTV identity test failed] " .. message)
	end
end

local function validate(profile: any): (boolean, string?)
	return PlayerProfileSchema.Validate(profile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog, PlayerIdentityPolicy)
end

local function migrate(profile: any): (any?, string?)
	return PlayerProfileSchema.Migrate(profile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog, PlayerIdentityPolicy)
end

-- 1. The rule itself.
expect(PlayerIdentityPolicy.IsPlayerIdentity("covenant_operative").ok, "the default operative identity is valid")
expect(PlayerIdentityPolicy.IsPlayerIdentity("operative_7742").ok, "a lower case operative identity is valid")
expect(not PlayerIdentityPolicy.IsPlayerIdentity("").ok, "an empty identity is rejected")
expect(not PlayerIdentityPolicy.IsPlayerIdentity(nil).ok, "a missing identity is rejected")
expect(not PlayerIdentityPolicy.IsPlayerIdentity("CovenantOperative").ok, "an upper case identity is rejected")
expect(not PlayerIdentityPolicy.IsPlayerIdentity("operative-7").ok, "an identity with punctuation is rejected")
expect(not PlayerIdentityPolicy.IsPlayerIdentity(string.rep("a", 65)).ok, "an over-long identity is rejected")
expect(not PlayerIdentityPolicy.IsPlayerIdentity("asher_vance").ok, "the protagonist's identity is never a player identity")
expect(not PlayerIdentityPolicy.IsPlayerIdentity("chosen_one").ok, "an identity that names the Chosen role is rejected")
expect(not PlayerIdentityPolicy.IsPlayerIdentity("roblox_player_chosen").ok, "the earlier every-player-is-Chosen identity is rejected")
expect(PlayerIdentityPolicy.IsReservedCharacterId("asher_vance"), "the protagonist identity is reserved")
expect(not PlayerIdentityPolicy.IsReservedCharacterId("covenant_operative"), "an operative identity is not reserved")

-- 2. The default profile carries the operative identity, not the protagonist's.
local defaultProfile = PlayerProfileSchema.CreateDefault()
expect(defaultProfile.identity.characterId == PlayerIdentityPolicy.GetDefaultOperativeId(), "the default profile uses the policy's operative identity")
expect(defaultProfile.identity.characterId ~= "asher_vance", "the default profile never carries the protagonist's identity")
expect(validate(defaultProfile), "the default profile passes validation")

-- 3. A current profile that claims the protagonist's identity is rejected.
local asherProfile = PlayerProfileSchema.CreateDefault()
asherProfile.identity.characterId = "asher_vance"
local asherValid, asherReason = validate(asherProfile)
expect(not asherValid, "a profile claiming the protagonist's identity is rejected")
expect(asherReason ~= nil and string.find(asherReason, "reserved", 1, true) ~= nil, "the rejection explains that the identity is reserved")

-- 4. A current profile that claims the Chosen role is rejected.
local chosenProfile = PlayerProfileSchema.CreateDefault()
chosenProfile.identity.characterId = "chosen_one"
expect(not validate(chosenProfile), "a profile claiming the Chosen role is rejected")

local legacyChosenProfile = PlayerProfileSchema.CreateDefault()
legacyChosenProfile.identity.characterId = "roblox_player_chosen"
expect(not validate(legacyChosenProfile), "a current profile with the earlier Chosen identity is rejected")

-- 5. A profile stored before the rule migrates forward and is normalised, not rejected.
local storedBeforeRule = PlayerProfileSchema.CreateDefault()
storedBeforeRule.schemaVersion = 3
storedBeforeRule.identity.characterId = "roblox_player_chosen"
storedBeforeRule.economy.aces = 25
local migrated, migrationError = migrate(storedBeforeRule)
expect(migrated ~= nil, "a stored profile from before the identity rule migrates: " .. tostring(migrationError))
assert(migrated ~= nil, "migrated profile must exist")
expect(migrated.schemaVersion == 4, "the migrated profile carries the current schema version")
expect(migrated.identity.characterId == PlayerIdentityPolicy.GetDefaultOperativeId(), "the migrated profile carries the operative identity")
expect(migrated.economy.aces == 25, "the migration preserves the player's balances")
expect(validate(migrated), "the migrated profile passes current validation")

-- 6. A stored profile that claims the protagonist's identity is normalised too.
local storedAsherProfile = PlayerProfileSchema.CreateDefault()
storedAsherProfile.schemaVersion = 3
storedAsherProfile.identity.characterId = "asher_vance"
local migratedAsher, migratedAsherError = migrate(storedAsherProfile)
expect(migratedAsher ~= nil, "a stored profile claiming the protagonist's identity migrates: " .. tostring(migratedAsherError))
assert(migratedAsher ~= nil, "migrated profile must exist")
expect(migratedAsher.identity.characterId == PlayerIdentityPolicy.GetDefaultOperativeId(), "a stored protagonist identity is replaced by the operative identity")
expect(not validate(storedAsherProfile), "the unmigrated stored profile still fails current validation")

-- 7. A migration must not mutate the stored profile it was given.
expect(storedBeforeRule.identity.characterId == "roblox_player_chosen", "the migration does not rewrite the stored profile in place")

print("[BTV identity test] passed")
return true
