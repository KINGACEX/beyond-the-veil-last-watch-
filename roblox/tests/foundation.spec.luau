--!strict
-- Headless regression checks for pure BTV Roblox rules.
-- Run from the roblox directory with: lune run tests/foundation.spec.luau

local MissionService = require("../src/server/Services/MissionService")
local CompanionCatalog = require("../src/shared/CompanionCatalog")
local CompanionOwnershipPolicy = require("../src/server/Services/CompanionOwnershipPolicy")
local CompanionRigContract = require("../src/shared/CompanionRigContract")
local ArchiveService = require("../src/server/Services/ArchiveService")
local CovenantRankCatalog = require("../src/shared/CovenantRankCatalog")
local PlayerProfileSchema = require("../src/shared/PlayerProfileSchema")
local ProfileLeasePolicy = require("../src/shared/ProfileLeasePolicy")
local ProfileRecordPolicy = require("../src/shared/ProfileRecordPolicy")
local FakeProfileStore = require("./support/FakeProfileStore")
local ProfilePersistenceAdapter = require("../src/server/Services/ProfilePersistenceAdapter")
local ItemCatalog = require("../src/shared/ItemCatalog")
local InventoryPolicy = require("../src/shared/InventoryPolicy")
local MerchantTransactionPolicy = require("../src/shared/MerchantTransactionPolicy")
local MerchantService = require("../src/server/Services/MerchantService")
local BuildModuleCatalog = require("../src/shared/BuildModuleCatalog")
local PropertyCatalog = require("../src/shared/PropertyCatalog")
local PropertyPolicy = require("../src/shared/PropertyPolicy")
local ConstructionPlacementPolicy = require("../src/shared/ConstructionPlacementPolicy")

local function expect(condition: boolean, message: string)
	if not condition then
		error("[BTV test failed] " .. message)
	end
end

do
	local player = { UserId = 901001 }
	
	-- Mission progression is server-owned, sequential and rejects skipped phases.
	MissionService.AddPlayer(player :: any)
	local initial = MissionService.GetSnapshot(player :: any)
	expect(initial ~= nil, "new player receives a mission snapshot")
	assert(initial ~= nil, "mission snapshot must exist")
	expect(initial.phase == "communion_context", "mission starts in Communion context")
	expect(initial.sequenceIndex == 1, "initial mission index is one")
	expect(initial.objective == "Enter the sanctuary", "initial objective is correct")
	
	local skipped = MissionService.Advance(player :: any, "communion_context", "report_accessed")
	expect(skipped == false, "mission cannot skip the Covenant alert phase")
	
	local advanced, alert = MissionService.Advance(player :: any, "communion_context", "covenant_alert")
	expect(advanced, "sanctuary transition advances to Covenant alert")
	expect(alert ~= nil and alert.sequenceIndex == 2, "Covenant alert is sequence two")
	assert(alert ~= nil, "Covenant alert snapshot must exist")
	
	local repeated = MissionService.Advance(player :: any, "communion_context", "covenant_alert")
	expect(repeated == false, "stale phase cannot advance twice")
	
	local reportAdvanced, report = MissionService.Advance(player :: any, "covenant_alert", "report_accessed")
	expect(reportAdvanced, "Scout Report access advances the final opening phase")
	expect(report ~= nil and report.sequenceIndex == 3, "report phase is sequence three")
	assert(report ~= nil, "report snapshot must exist")
	expect(string.find(report.objective, "evidence pending", 1, true) ~= nil, "report does not invent evidence")
	
	local travelAdvanced, arrival = MissionService.Advance(player :: any, "report_accessed", "ridgeview_arrival")
	expect(travelAdvanced, "Ridgeview arrival follows Scout Report access")
	expect(arrival ~= nil and arrival.sequenceIndex == 4, "Ridgeview arrival is sequence four")
	assert(arrival ~= nil, "Ridgeview arrival snapshot must exist")
	expect(arrival.objective == "Arrive at Ridgeview", "Ridgeview arrival objective is correct")
	
	local skippedFinal = MissionService.Advance(player :: any, "communion_context", "ridgeview_arrival")
	expect(skippedFinal == false, "mission cannot jump directly to Ridgeview")
	
	MissionService.RemovePlayer(player :: any)
	expect(MissionService.GetSnapshot(player :: any) == nil, "player state is cleared on removal")
	
	-- Companion roster integrity and fairness guardrails.
	local required = { "Ember", "Eagle", "Fox", "Bear", "Owl", "Leopard", "Horse", "Falcon" }
	for _, name in required do
		expect(CompanionCatalog[name] ~= nil, "companion exists: " .. name)
	end
	
	local premiumCount = 0
	for name, companion in CompanionCatalog do
		expect(companion.DisplayName == name, "display name matches catalog key: " .. name)
		if companion.Access == "PremiumCandidate" then
			premiumCount += 1
			expect(companion.FreeEquivalent ~= nil, "premium candidate has a free equivalent: " .. name)
		end
	end
	expect(premiumCount == 4, "exactly four animals are premium candidates")
	
	local ember = CompanionCatalog.Ember
	expect(ember.CoreCommands ~= nil and #ember.CoreCommands == 7, "Ember retains all seven core commands")
	
	-- Session maps are created independently by the server-side ownership policy.
	local firstSessionOwnership = CompanionOwnershipPolicy.CreateDefaultOwnership()
	local secondSessionOwnership = CompanionOwnershipPolicy.CreateDefaultOwnership()
	
	-- Every premium candidate points to a selectable free baseline, not a mission gate.
	for name, companion in CompanionCatalog do
		if companion.Access == "PremiumCandidate" then
			local freeEquivalent = companion.FreeEquivalent and CompanionCatalog[companion.FreeEquivalent]
			expect(freeEquivalent ~= nil, name .. " has a catalogued free equivalent")
			assert(freeEquivalent ~= nil, name .. " free equivalent must exist")
			expect(freeEquivalent.Access == "Core" or freeEquivalent.Access == "Free", name .. " free equivalent is not premium")
			expect(firstSessionOwnership[freeEquivalent.Id] == true, name .. " free equivalent is initially available")
		end
	end
	
	-- Ember's imported rig contract is explicit and presentation-only.
	expect(CompanionRigContract.AssetFolderName == "BTVAssets", "Ember asset folder is server-owned")
	expect(CompanionRigContract.CompanionFolderName == "Companions", "Ember asset folder is separated by companion")
	expect(CompanionRigContract.ModelName == "Ember", "Ember model has a stable import name")
	expect(CompanionRigContract.RootPartName == "CompanionRoot", "Ember rig root contract is explicit")
	expect(#CompanionRigContract.RequiredAnimations == 3, "Ember rig requires three presentation clips")
	expect(CompanionRigContract.RequiredAnimations[1] == "Idle_Breathing", "Ember idle clip is named")
	expect(CompanionRigContract.RequiredAnimations[2] == "Walk_Cycle", "Ember walk clip is named")
	expect(CompanionRigContract.RequiredAnimations[3] == "Alert_Acknowledge", "Ember acknowledgement clip is named")
	expect(CompanionRigContract.AnimationSettings.Idle_Breathing.Looped, "Ember idle loops")
	expect(CompanionRigContract.AnimationSettings.Walk_Cycle.Looped, "Ember walk loops")
	expect(not CompanionRigContract.AnimationSettings.Alert_Acknowledge.Looped, "Ember acknowledgement is a one-shot presentation")
	expect(CompanionRigContract.AnimationSettings.Alert_Acknowledge.Priority == "Action", "Ember acknowledgement has action presentation priority")
	
	-- Ember's seven commands are available only while Ember is the equipped companion.
	local canUseEmber, emberReason = CompanionOwnershipPolicy.CanUseEmberCommands("ember")
	expect(canUseEmber, "Ember commands are allowed while Ember is equipped")
	expect(emberReason == nil, "valid Ember command state has no rejection reason")
	for _, companionId in { "fox", "owl", "horse", "eagle", "bear", "leopard", "falcon" } do
		local canUse, reason = CompanionOwnershipPolicy.CanUseEmberCommands(companionId)
		expect(canUse == false, "Ember commands are blocked for another equipped companion: " .. companionId)
		expect(reason ~= nil, "blocked Ember command state returns a reason: " .. companionId)
	end
	local malformedCommandOwner = CompanionOwnershipPolicy.CanUseEmberCommands(42)
	expect(malformedCommandOwner == false, "malformed equipped companion state cannot use Ember commands")
	
	-- Free catalog membership is not enough: the current player's own map must grant access.
	local unownedFreeOwnership = table.clone(firstSessionOwnership)
	unownedFreeOwnership.fox = false
	local unownedFreeAccepted, unownedFreeReason = CompanionOwnershipPolicy.CanEquip("fox", unownedFreeOwnership, CompanionCatalog)
	expect(unownedFreeAccepted == false, "a free companion cannot be equipped when absent from this player's ownership map")
	expect(unownedFreeReason ~= nil, "unowned free companion returns a rejection reason")
	expect(firstSessionOwnership.fox == true, "failed selection cannot mutate the source ownership map")
	expect(unownedFreeOwnership.fox == false, "selection validation does not silently grant ownership")
	
	-- Server ownership policy: default access is isolated, explicit and fail-closed.
	local defaultOwnedCount = 0
	for companionId, isOwned in firstSessionOwnership do
		if isOwned then
			defaultOwnedCount += 1
		end
		local selectable, reason = CompanionOwnershipPolicy.CanEquip(companionId, firstSessionOwnership, CompanionCatalog)
		expect(selectable, "default-owned companion is selectable: " .. companionId)
		expect(reason == nil, "valid default selection has no rejection reason")
	end
	expect(defaultOwnedCount == 4, "exactly four companions are initially owned")
	expect(firstSessionOwnership.ember == true, "Ember is initially owned")
	expect(firstSessionOwnership.fox == true, "Fox is initially owned")
	expect(firstSessionOwnership.owl == true, "Owl is initially owned")
	expect(firstSessionOwnership.horse == true, "Horse is initially owned")
	expect(firstSessionOwnership.eagle ~= true, "Eagle is not initially owned")
	expect(firstSessionOwnership.bear ~= true, "Bear is not initially owned")
	expect(firstSessionOwnership.leopard ~= true, "Leopard is not initially owned")
	expect(firstSessionOwnership.falcon ~= true, "Falcon is not initially owned")
	
	-- A forged ownership entry cannot bypass the premium-candidate access gate.
	for _, companionId in { "eagle", "bear", "leopard", "falcon" } do
		local forgedOwnership = table.clone(firstSessionOwnership)
		forgedOwnership[companionId] = true
		local accepted = CompanionOwnershipPolicy.CanEquip(companionId, forgedOwnership, CompanionCatalog)
		expect(accepted == false, "premium candidate remains blocked even if marked owned: " .. companionId)
	end
	
	local unknownAccepted = CompanionOwnershipPolicy.CanEquip("dragon", firstSessionOwnership, CompanionCatalog)
	expect(unknownAccepted == false, "unknown companion ID is rejected")
	local malformedAccepted = CompanionOwnershipPolicy.CanEquip(42, firstSessionOwnership, CompanionCatalog)
	expect(malformedAccepted == false, "non-string companion ID is rejected")
	local nilAccepted = CompanionOwnershipPolicy.CanEquip(nil, firstSessionOwnership, CompanionCatalog)
	expect(nilAccepted == false, "nil companion ID is rejected")
	
	firstSessionOwnership.fox = false
	expect(secondSessionOwnership.fox == true, "one session cannot mutate another session's ownership map")
	local freshOwnership = CompanionOwnershipPolicy.CreateDefaultOwnership()
	expect(freshOwnership.fox == true, "mutating a session snapshot cannot change default ownership")
	
	print("[BTV tests] Foundation and companion ownership rules passed.")
end

-- Curiosity Archive discoveries are server-owned, session-only and non-economic.
do
	local archivePlayer = { UserId = 901002 }
	local otherArchivePlayer = { UserId = 901003 }
	ArchiveService.AddPlayer(archivePlayer)
	ArchiveService.AddPlayer(otherArchivePlayer)
	local archiveInitial = ArchiveService.GetSnapshot(archivePlayer, 0)
	expect(archiveInitial ~= nil and archiveInitial.collectedCount == 0, "archive starts with no discoveries")
	expect(archiveInitial ~= nil and archiveInitial.requiredCount == 3 and not archiveInitial.unlocked, "archive requires three marks")
	local unknownMark = ArchiveService.Collect(archivePlayer, "story_evidence")
	expect(unknownMark == false, "unknown archive mark is rejected")
	local firstMark, firstSnapshot = ArchiveService.Collect(archivePlayer, "ridge_marker")
	expect(firstMark and firstSnapshot ~= nil and firstSnapshot.collectedCount == 1, "first curio mark is recorded")
	local duplicateMark, duplicateSnapshot = ArchiveService.Collect(archivePlayer, "ridge_marker")
	expect(not duplicateMark and duplicateSnapshot ~= nil and duplicateSnapshot.collectedCount == 1, "duplicate mark does not increase progress")
	local secondMark, secondSnapshot = ArchiveService.Collect(archivePlayer, "stream_marker")
	expect(secondMark and secondSnapshot ~= nil and secondSnapshot.collectedCount == 2, "second curio mark is recorded")
	local otherSnapshot = ArchiveService.GetSnapshot(otherArchivePlayer)
	expect(otherSnapshot ~= nil and otherSnapshot.collectedCount == 0, "archive progress is isolated per player")
	local thirdMark, unlockedSnapshot = ArchiveService.Collect(archivePlayer, "lookout_marker")
	expect(thirdMark and unlockedSnapshot ~= nil and unlockedSnapshot.unlocked, "third mark unlocks archive")
	expect(unlockedSnapshot ~= nil and unlockedSnapshot.collectedCount == 3, "archive unlock requires all three marks")
	expect(ArchiveService.GetDisplayTitle(0) ~= ArchiveService.GetDisplayTitle(604800), "weekly display rotates by UTC week")
	ArchiveService.RemovePlayer(archivePlayer)
	ArchiveService.RemovePlayer(otherArchivePlayer)
	expect(ArchiveService.GetSnapshot(archivePlayer) == nil, "archive state is cleared on player removal")
end

do
	-- Versioned profile schema validation is pure and does not enable DataStore writes.
	local defaultProfile = PlayerProfileSchema.CreateDefault()
	local validProfile, validProfileReason = PlayerProfileSchema.Validate(defaultProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(validProfile, "new versioned profile passes schema validation")
	expect(validProfileReason == nil, "valid profile has no validation error")
	expect(defaultProfile.schemaVersion == 3, "new profile uses the current schema version")
	expect(defaultProfile.progression.covenantRank == "Recruit", "new profile starts at Recruit")
	expect(defaultProfile.companions.owned.ember == true, "new profile owns Ember")
	expect(defaultProfile.companions.owned.fox == true, "new profile owns Fox")
	expect(defaultProfile.companions.owned.owl == true, "new profile owns Owl")
	expect(defaultProfile.companions.owned.horse == true, "new profile owns Horse")
	expect(defaultProfile.companions.owned.eagle ~= true, "new profile does not grant premium candidates")
	
	local unsupportedProfile = table.clone(defaultProfile)
	unsupportedProfile.schemaVersion = 99
	local unsupportedValid = PlayerProfileSchema.Validate(unsupportedProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not unsupportedValid, "unsupported profile schema is rejected")
	
	local unknownRankProfile = table.clone(defaultProfile)
	unknownRankProfile.progression = table.clone(defaultProfile.progression)
	unknownRankProfile.progression.covenantRank = "Supreme Commander"
	local unknownRankValid = PlayerProfileSchema.Validate(unknownRankProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not unknownRankValid, "unknown Covenant rank is rejected")
	
	local negativeBalanceProfile = table.clone(defaultProfile)
	negativeBalanceProfile.economy = table.clone(defaultProfile.economy)
	negativeBalanceProfile.economy.aces = -1
	local negativeBalanceValid = PlayerProfileSchema.Validate(negativeBalanceProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not negativeBalanceValid, "negative currency balance is rejected")
	
	local fractionalBalanceProfile = table.clone(defaultProfile)
	fractionalBalanceProfile.economy = table.clone(defaultProfile.economy)
	fractionalBalanceProfile.economy.covenantCredits = 1.5
	local fractionalBalanceValid = PlayerProfileSchema.Validate(fractionalBalanceProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not fractionalBalanceValid, "fractional currency balance is rejected")
	
	local forgedPremiumProfile = table.clone(defaultProfile)
	forgedPremiumProfile.companions = table.clone(defaultProfile.companions)
	forgedPremiumProfile.companions.owned = table.clone(defaultProfile.companions.owned)
	forgedPremiumProfile.companions.owned.eagle = true
	local forgedPremiumValid = PlayerProfileSchema.Validate(forgedPremiumProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not forgedPremiumValid, "profile cannot forge premium companion ownership")
	
	local unownedEquippedProfile = table.clone(defaultProfile)
	unownedEquippedProfile.companions = table.clone(defaultProfile.companions)
	unownedEquippedProfile.companions.equipped = "eagle"
	local unownedEquippedValid = PlayerProfileSchema.Validate(unownedEquippedProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not unownedEquippedValid, "profile cannot equip an unowned companion")
	
	local malformedEventsProfile = table.clone(defaultProfile)
	malformedEventsProfile.progression = table.clone(defaultProfile.progression)
	malformedEventsProfile.progression.completedMissionIds = { [1] = "mission_a", [3] = "mission_c" }
	local malformedEventsValid = PlayerProfileSchema.Validate(malformedEventsProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not malformedEventsValid, "sparse progression event lists are rejected")
	
	local duplicateEventsProfile = table.clone(defaultProfile)
	duplicateEventsProfile.progression = table.clone(defaultProfile.progression)
	duplicateEventsProfile.progression.completedEvaluations = { "evaluation_001", "evaluation_001" }
	local duplicateEventsValid = PlayerProfileSchema.Validate(duplicateEventsProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(not duplicateEventsValid, "duplicate evaluation IDs are rejected")
	
	defaultProfile.companions.owned.fox = false
	local independentDefault = PlayerProfileSchema.CreateDefault()
	expect(independentDefault.companions.owned.fox == true, "mutating one profile cannot mutate future default profiles")
end

do
	-- Cross-server profile lease policy is deterministic and fails closed.
	local firstLease, firstLeaseError = ProfileLeasePolicy.TryAcquire(nil, "server-A", 100, 60)
	expect(firstLease ~= nil and firstLeaseError == nil, "empty profile lease can be acquired")
	assert(firstLease ~= nil, "first profile lease must exist")
	expect(firstLease.ownerToken == "server-A" and firstLease.expiresAt == 160, "lease records owner and expiry")
	expect(ProfileLeasePolicy.IsOwner(firstLease, "server-A", 159), "owner holds lease before expiry")
	expect(not ProfileLeasePolicy.IsOwner(firstLease, "server-A", 160), "lease expires at its exact expiry time")
	
	local competingLease, competingError = ProfileLeasePolicy.TryAcquire(firstLease, "server-B", 120, 60)
	expect(competingLease == nil and competingError ~= nil, "second server cannot steal an unexpired lease")
	
	local renewedLease, renewedError = ProfileLeasePolicy.TryAcquire(firstLease, "server-A", 130, 60)
	expect(renewedLease ~= nil and renewedError == nil, "same owner can renew its lease")
	expect(renewedLease ~= nil and renewedLease.expiresAt == 190, "renewal extends from the supplied server time")
	
	local staleTakeover, staleTakeoverError = ProfileLeasePolicy.TryAcquire(firstLease, "server-B", 160, 60)
	expect(staleTakeover ~= nil and staleTakeoverError == nil, "another server can take over an expired lease")
	expect(staleTakeover ~= nil and staleTakeover.ownerToken == "server-B", "expired lease takeover changes owner")
	
	local wrongOwnerRelease, retainedLease = ProfileLeasePolicy.TryRelease(firstLease, "server-B")
	expect(not wrongOwnerRelease and retainedLease == firstLease, "non-owner cannot release another server lease")
	local ownerRelease, releasedLease = ProfileLeasePolicy.TryRelease(firstLease, "server-A")
	expect(ownerRelease and releasedLease == nil, "matching owner can release its lease")
	
	local malformedLease, malformedLeaseError = ProfileLeasePolicy.TryAcquire({ ownerToken = "server-X", expiresAt = "later" }, "server-B", 200, 60)
	expect(malformedLease == nil and malformedLeaseError ~= nil, "malformed stored lease fails closed")
	local invalidDuration, invalidDurationError = ProfileLeasePolicy.TryAcquire(nil, "server-A", 100, 0)
	expect(invalidDuration == nil and invalidDurationError ~= nil, "zero-duration lease request is rejected")
	local emptyToken, emptyTokenError = ProfileLeasePolicy.TryAcquire(nil, "", 100, 60)
	expect(emptyToken == nil and emptyTokenError ~= nil, "empty owner token is rejected")
	local nanLease, nanLeaseError = ProfileLeasePolicy.TryAcquire(nil, "server-A", 0 / 0, 60)
	expect(nanLease == nil and nanLeaseError ~= nil, "non-finite lease clock is rejected")
	
	print("[BTV tests] Profile lease policy rules passed.")
end

-- Atomic DataStore callback transformations preserve ownership and reject stale writes.
local acquiredRecord, acquiredRecordError =
	ProfileRecordPolicy.TryAcquire(nil, "server-A", 100, 60, PlayerProfileSchema, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog, ProfileLeasePolicy)
expect(acquiredRecord ~= nil and acquiredRecordError == nil, "new profile record can be initialized with a lease")
assert(acquiredRecord ~= nil, "acquired profile record must exist")
expect(acquiredRecord.profile.progression.covenantRank == "Recruit", "new record starts at Recruit")
expect(acquiredRecord.profile.revision == 0, "new record starts at revision zero")

do
	-- Legacy profiles migrate to v3 without losing established progress or balances.
	local legacyProfile = PlayerProfileSchema.CreateDefault()
	legacyProfile.schemaVersion = 1
	legacyProfile.inventory = nil
	legacyProfile.economy.aces = 91
	legacyProfile.progression.completedMissionIds = { "mission-legacy-001" }
	local migratedProfile, migrationError = PlayerProfileSchema.Migrate(legacyProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(migratedProfile ~= nil and migrationError == nil, "valid v1 profile migrates to the current schema")
	assert(migratedProfile ~= nil, "migrated profile must exist")
	expect(migratedProfile.schemaVersion == 3, "migration advances profile schema to version three")
	expect(migratedProfile.economy.aces == 91, "migration preserves existing Aces")
	expect(migratedProfile.progression.completedMissionIds[1] == "mission-legacy-001", "migration preserves mission progress")
	expect(migratedProfile.inventory.items ~= nil and next(migratedProfile.inventory.items) == nil, "migration adds an empty inventory")
	expect(legacyProfile.schemaVersion == 1 and legacyProfile.inventory == nil, "migration does not mutate the stored legacy profile")

	local invalidLegacyProfile = PlayerProfileSchema.CreateDefault()
	invalidLegacyProfile.schemaVersion = 1
	invalidLegacyProfile.inventory = nil
	invalidLegacyProfile.economy.aces = -1
	local rejectedLegacy, rejectedLegacyError = PlayerProfileSchema.Migrate(invalidLegacyProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(rejectedLegacy == nil and rejectedLegacyError ~= nil, "malformed legacy profiles fail closed")

	local invalidInventoryProfile = PlayerProfileSchema.CreateDefault()
	invalidInventoryProfile.inventory.items.unknown_item = 1
	local invalidInventoryProfileValid, invalidInventoryProfileError =
		PlayerProfileSchema.Validate(invalidInventoryProfile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(invalidInventoryProfileValid == false and invalidInventoryProfileError ~= nil, "current schema rejects unknown inventory item IDs")

	local migratedRecord, migratedRecordError = ProfileRecordPolicy.TryAcquire(
		{ profile = legacyProfile, lease = nil },
		"migration-server",
		100,
		60,
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog,
		ProfileLeasePolicy
	)
	expect(migratedRecord ~= nil and migratedRecordError == nil, "atomic record acquisition migrates a valid legacy profile")
	assert(migratedRecord ~= nil, "migrated record must exist")
	expect(migratedRecord.profile.schemaVersion == 3, "acquired record contains the current schema")
	expect(migratedRecord.profile.economy.aces == 91, "record migration preserves the legacy balance")

	local legacyV2Profile = PlayerProfileSchema.CreateDefault()
	legacyV2Profile.schemaVersion = 2
	legacyV2Profile.economy.recentTransactions = nil
	legacyV2Profile.economy.aces = 37
	legacyV2Profile.inventory.items.timber_plank = 4
	local migratedV2Profile, migratedV2Error = PlayerProfileSchema.Migrate(legacyV2Profile, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog)
	expect(migratedV2Profile ~= nil and migratedV2Error == nil, "valid v2 profile migrates to v3")
	assert(migratedV2Profile ~= nil, "migrated v2 profile must exist")
	expect(migratedV2Profile.schemaVersion == 3, "v2 migration advances the schema version")
	expect(migratedV2Profile.economy.aces == 37, "v2 migration preserves Aces")
	expect(migratedV2Profile.inventory.items.timber_plank == 4, "v2 migration preserves inventory")
	expect(#migratedV2Profile.economy.recentTransactions == 0, "v2 migration initializes a bounded transaction journal")
end

local occupiedRecord, occupiedError = ProfileRecordPolicy.TryAcquire(
	acquiredRecord,
	"server-B",
	120,
	60,
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(occupiedRecord == nil and occupiedError ~= nil, "competing server cannot acquire an active profile record")

local candidateProfile = PlayerProfileSchema.CreateDefault()
candidateProfile.economy.aces = 25
local savedRecord, savedError, savedOutcome = ProfileRecordPolicy.TrySave(
	acquiredRecord,
	"server-A",
	130,
	60,
	candidateProfile,
	"save-operation-001",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(savedRecord ~= nil and savedError == nil, "current owner can save a valid profile")
expect(savedOutcome == "Saved", "new save is explicitly classified as saved")
assert(savedRecord ~= nil, "saved record must exist")
expect(savedRecord.profile.economy.aces == 25, "save persists candidate economy values")
expect(savedRecord.profile.revision == 1, "successful save increments profile revision")
expect(savedRecord.lastSaveOperation.id == "save-operation-001", "save records its operation ID")
expect(savedRecord.lastSaveOperation.baseRevision == 0 and savedRecord.lastSaveOperation.resultRevision == 1, "save records its revision transition")
expect(acquiredRecord.profile.economy.aces == 0, "save transformation does not mutate stored input")
-- A retried save reconciles an ambiguous UpdateAsync result without applying twice.
local replayedRecord, replayError, replayOutcome = ProfileRecordPolicy.TrySave(
	savedRecord,
	"server-A",
	500,
	60,
	candidateProfile,
	"save-operation-001",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(replayedRecord == savedRecord and replayError == nil, "exact retry returns the already committed record")
expect(replayOutcome == "AlreadyApplied", "exact retry is classified as already applied")
expect(replayedRecord ~= nil and replayedRecord.profile.revision == 1, "retry does not increment revision twice")

local reusedOperationCandidate = PlayerProfileSchema.CreateDefault()
reusedOperationCandidate.economy.aces = 26
local reusedOperation, reusedOperationError = ProfileRecordPolicy.TrySave(
	savedRecord,
	"server-A",
	140,
	60,
	reusedOperationCandidate,
	"save-operation-001",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(reusedOperation == nil and reusedOperationError ~= nil, "same operation ID with a different payload is rejected")

local invalidOperation, invalidOperationError = ProfileRecordPolicy.TrySave(
	savedRecord,
	"server-A",
	140,
	60,
	candidateProfile,
	"",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(invalidOperation == nil and invalidOperationError ~= nil, "empty save operation ID is rejected")

local reacquiredAfterSave, reacquireAfterSaveError =
	ProfileRecordPolicy.TryAcquire(savedRecord, "server-B", 200, 60, PlayerProfileSchema, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog, ProfileLeasePolicy)
expect(reacquiredAfterSave ~= nil and reacquireAfterSaveError == nil, "expired saved record can be acquired by a later session")
expect(reacquiredAfterSave ~= nil and reacquiredAfterSave.lastSaveOperation.id == "save-operation-001", "last save operation marker survives acquisition")

local staleCandidate = PlayerProfileSchema.CreateDefault()
staleCandidate.economy.aces = 999
local staleSave, staleSaveError = ProfileRecordPolicy.TrySave(
	savedRecord,
	"server-A",
	140,
	60,
	staleCandidate,
	"save-operation-002",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(staleSave == nil and staleSaveError ~= nil, "stale profile revision cannot overwrite a newer save")

local expiredSave, expiredSaveError = ProfileRecordPolicy.TrySave(
	savedRecord,
	"server-A",
	190,
	60,
	candidateProfile,
	"save-operation-003",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(expiredSave == nil and expiredSaveError ~= nil, "expired owner cannot save without reacquiring lease")

local malformedCandidate = PlayerProfileSchema.CreateDefault()
malformedCandidate.economy.aces = -50
local invalidSave, invalidSaveError = ProfileRecordPolicy.TrySave(
	savedRecord,
	"server-A",
	150,
	60,
	malformedCandidate,
	"save-operation-invalid",
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(invalidSave == nil and invalidSaveError ~= nil, "invalid candidate profile cannot be saved")

local releasedRecord, releaseError = ProfileRecordPolicy.TryRelease(savedRecord, "server-A", ProfileLeasePolicy)
expect(releasedRecord ~= nil and releaseError == nil, "current owner can release its profile record")
assert(releasedRecord ~= nil, "released record must exist")
expect(releasedRecord.lease == nil, "release clears the lease while retaining profile")
expect(releasedRecord.profile.revision == 1, "release preserves saved revision")
expect(releasedRecord.lastSaveOperation.id == "save-operation-001", "release preserves save reconciliation marker")

local wrongRelease, wrongReleaseError = ProfileRecordPolicy.TryRelease(savedRecord, "server-B", ProfileLeasePolicy)
expect(wrongRelease == nil and wrongReleaseError ~= nil, "non-owner cannot release profile record")

local malformedStored, malformedStoredError = ProfileRecordPolicy.TryAcquire(
	{ profile = { schemaVersion = 99 }, lease = nil },
	"server-B",
	200,
	60,
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(malformedStored == nil and malformedStoredError ~= nil, "unsupported stored profile cannot be overwritten")

local malformedSaveMarker, malformedSaveMarkerError = ProfileRecordPolicy.TryAcquire(
	{ profile = PlayerProfileSchema.CreateDefault(), lease = nil, lastSaveOperation = { id = "broken" } },
	"server-B",
	200,
	60,
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	InventoryPolicy,
	ItemCatalog,
	ProfileLeasePolicy
)
expect(malformedSaveMarker == nil and malformedSaveMarkerError ~= nil, "malformed save-operation marker fails closed")
print("[BTV tests] Profile record policy rules passed.")

-- Fake storage exercises UpdateAsync callback replay and ambiguous write outcomes.
local fakeStore = FakeProfileStore.new()
local profileKey = "player:901001"
fakeStore:QueueCallbackReplay(profileKey, acquiredRecord)
local replayedAcquire, replayedAcquireError = fakeStore:UpdateAsync(profileKey, function(existing)
	local nextRecord, policyError =
		ProfileRecordPolicy.TryAcquire(existing, "server-B", 120, 60, PlayerProfileSchema, CovenantRankCatalog, CompanionCatalog, InventoryPolicy, ItemCatalog, ProfileLeasePolicy)
	if policyError ~= nil then
		return nil
	end
	return nextRecord
end)
expect(replayedAcquire == nil and replayedAcquireError == nil, "callback replay observes a competing active lease")
expect(fakeStore.callbackCallCount == 2, "fake store invokes UpdateAsync transformation again after a competing write")
local competingStoredRecord = fakeStore:Get(profileKey)
expect(competingStoredRecord ~= nil and competingStoredRecord.lease.ownerToken == "server-A", "callback replay preserves the competing server's record")

local ambiguousStore = FakeProfileStore.new()
ambiguousStore:Set(profileKey, acquiredRecord)
ambiguousStore:QueueFailure("AfterCommit", "simulated response loss after durable commit")
local firstAmbiguousOutcome = nil
local ambiguousResult, ambiguousError = ambiguousStore:UpdateAsync(profileKey, function(existing)
	local nextRecord, policyError, outcome = ProfileRecordPolicy.TrySave(
		existing,
		"server-A",
		130,
		60,
		candidateProfile,
		"save-operation-ambiguous",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog,
		ProfileLeasePolicy
	)
	firstAmbiguousOutcome = outcome
	if policyError ~= nil then
		return nil
	end
	return nextRecord
end)
expect(ambiguousResult == nil and ambiguousError == "simulated response loss after durable commit", "fake store can simulate an ambiguous committed write")
expect(firstAmbiguousOutcome == "Saved", "first ambiguous attempt computed a normal save")
local committedAfterLostResponse = ambiguousStore:Get(profileKey)
expect(committedAfterLostResponse ~= nil and committedAfterLostResponse.profile.revision == 1, "ambiguous write remains committed in fake storage")

local retryOutcome = nil
local reconciledResult, reconciledError = ambiguousStore:UpdateAsync(profileKey, function(existing)
	local nextRecord, policyError, outcome = ProfileRecordPolicy.TrySave(
		existing,
		"server-A",
		500,
		60,
		candidateProfile,
		"save-operation-ambiguous",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog,
		ProfileLeasePolicy
	)
	retryOutcome = outcome
	if policyError ~= nil then
		return nil
	end
	return nextRecord
end)
expect(reconciledError == nil and reconciledResult ~= nil, "retry reconciles a committed save after response loss")
expect(retryOutcome == "AlreadyApplied", "ambiguous retry is identified as already applied")
expect(reconciledResult ~= nil and reconciledResult.profile.revision == 1, "ambiguous retry does not double-increment profile revision")

local callbackCountBeforeFailure = ambiguousStore.callbackCallCount
ambiguousStore:QueueFailure("BeforeCallback", "simulated temporary service failure")
local unavailableResult, unavailableError = ambiguousStore:UpdateAsync(profileKey, function(existing)
	return existing
end)
expect(unavailableResult == nil and unavailableError == "simulated temporary service failure", "fake store can fail before invoking the callback")
expect(ambiguousStore.callbackCallCount == callbackCountBeforeFailure, "pre-callback failure does not execute transformation")

print("[BTV tests] Fake profile storage and ambiguous-write scenarios passed.")

-- Fake store isolation: callers cannot mutate durable records through aliases,
-- and a cancelled transform cannot alter the stored value.
local isolationStore = FakeProfileStore.new()
local seedRecord = {
	profile = PlayerProfileSchema.CreateDefault(),
	lease = { ownerToken = "server-isolation", expiresAt = 999 },
}
isolationStore:Set(profileKey, seedRecord)
seedRecord.profile.economy.aces = 777
local isolatedRead = isolationStore:Get(profileKey)
expect(isolatedRead.profile.economy.aces == 0, "Set stores a defensive copy of the supplied record")
isolatedRead.profile.economy.aces = 888
expect(isolationStore:Get(profileKey).profile.economy.aces == 0, "Get returns a defensive copy of the stored record")

local cancelledResult, cancelledError = isolationStore:UpdateAsync(profileKey, function(existing)
	existing.profile.economy.aces = 999
	return nil
end)
expect(cancelledResult == nil and cancelledError == nil, "nil transform result cancels the fake update")
expect(isolationStore:Get(profileKey).profile.economy.aces == 0, "cancelled transform cannot mutate stored data through its callback input")

print("[BTV tests] Fake store defensive-copy guarantees passed.")

do
	-- Injectable persistence adapter: retries only transient failures and reconciles ambiguous saves.
	local adapterStore = FakeProfileStore.new()
	local adapterClock = 100
	local adapterWaitCount = 0
	local adapter = ProfilePersistenceAdapter.new({
		Store = adapterStore,
		ProfileSchema = PlayerProfileSchema,
		RankCatalog = CovenantRankCatalog,
		CompanionCatalog = CompanionCatalog,
		InventoryPolicy = InventoryPolicy,
		ItemCatalog = ItemCatalog,
		LeasePolicy = ProfileLeasePolicy,
		RecordPolicy = ProfileRecordPolicy,
		Clock = function()
			return adapterClock
		end,
		Wait = function(_seconds)
			adapterWaitCount += 1
		end,
		GenerateToken = function()
			return "adapter-owner-token"
		end,
		Random = function()
			return 0
		end,
		MaxAttempts = 3,
		BaseDelaySeconds = 0.1,
		LeaseDurationSeconds = 120,
	})
	expect(ProfilePersistenceAdapter.GetKeyForUser(901002) == "player:901002", "adapter uses a stable namespaced user key")
	expect(ProfilePersistenceAdapter.GetKeyForUser(0) == nil, "adapter rejects invalid user IDs")

	local adapterSession, adapterAcquireError = adapter:Acquire(901002)
	expect(adapterSession ~= nil and adapterAcquireError == nil, "adapter acquires a new profile through the injected store")
	assert(adapterSession ~= nil, "adapter session must exist")
	expect(adapterSession.profile.progression.covenantRank == "Recruit", "adapter returns the validated default profile")
	expect(adapterSession.ownerToken == "adapter-owner-token", "adapter binds the session to its unique owner token")

	local adapterCandidate = adapterSession.profile
	adapterCandidate.economy.aces = 30
	local adapterSaved, adapterSaveError = adapter:Save(901002, adapterSession.ownerToken, adapterCandidate, "adapter-save-001")
	expect(adapterSaved ~= nil and adapterSaveError == nil, "adapter saves a valid profile")
	assert(adapterSaved ~= nil, "adapter save result must exist")
	expect(adapterSaved.revision == 1 and adapterSaved.outcome == "Saved", "adapter reports the committed revision and outcome")

	local retryCandidate = adapterSaved.profile
	retryCandidate.economy.aces = 45
	adapterStore:QueueFailure("BeforeCallback", "simulated temporary service failure")
	local retriedSave, retriedSaveError = adapter:Save(901002, adapterSession.ownerToken, retryCandidate, "adapter-save-002")
	expect(retriedSave ~= nil and retriedSaveError == nil, "adapter retries a transient pre-callback service failure")
	assert(retriedSave ~= nil, "retried save result must exist")
	expect(retriedSave.revision == 2 and retriedSave.profile.economy.aces == 45, "transient retry commits the intended snapshot")
	expect(adapterWaitCount == 1, "transient retry uses the injected backoff wait")

	local ambiguousCandidate = retriedSave.profile
	ambiguousCandidate.economy.aces = 55
	adapterStore:QueueFailure("AfterCommit", "simulated response loss after durable commit")
	local reconciledSave, reconcileError = adapter:Save(901002, adapterSession.ownerToken, ambiguousCandidate, "adapter-save-003")
	expect(reconciledSave ~= nil and reconcileError == nil, "adapter reconciles a committed save after response loss")
	assert(reconciledSave ~= nil, "reconciled save result must exist")
	expect(reconciledSave.revision == 3 and reconciledSave.outcome == "AlreadyApplied", "ambiguous retry does not duplicate the committed revision")
	expect(reconciledSave.profile.economy.aces == 55, "ambiguous retry preserves the exact saved payload")

	local competingAdapter = ProfilePersistenceAdapter.new({
		Store = adapterStore,
		ProfileSchema = PlayerProfileSchema,
		RankCatalog = CovenantRankCatalog,
		CompanionCatalog = CompanionCatalog,
		InventoryPolicy = InventoryPolicy,
		ItemCatalog = ItemCatalog,
		LeasePolicy = ProfileLeasePolicy,
		RecordPolicy = ProfileRecordPolicy,
		Clock = function()
			return adapterClock
		end,
		Wait = function(_seconds)
			adapterWaitCount += 1
		end,
		GenerateToken = function()
			return "competing-owner-token"
		end,
		Random = function()
			return 0
		end,
	})
	local competingSession, competingAcquireError = competingAdapter:Acquire(901002)
	expect(competingSession == nil and competingAcquireError ~= nil, "adapter refuses a competing active profile lease")
	expect(adapterWaitCount == 2, "domain lease contention is not retried as a transient service failure")

	local adapterReleased, adapterReleaseError = adapter:Release(901002, adapterSession.ownerToken)
	expect(adapterReleased and adapterReleaseError == nil, "adapter releases only its owned profile lease")
	local releasedAdapterRecord = adapterStore:Get("player:901002")
	expect(releasedAdapterRecord ~= nil and releasedAdapterRecord.lease == nil, "adapter release retains the profile while clearing its lease")

	print("[BTV tests] Injectable persistence adapter retry and recovery scenarios passed.")
end

do
	-- Construction supply inventory rules are bounded, immutable and price-independent.
	local emptyInventory = InventoryPolicy.CreateDefault()
	local validEmptyInventory, emptyInventoryError = InventoryPolicy.Validate(emptyInventory, ItemCatalog)
	expect(validEmptyInventory and emptyInventoryError == nil, "empty inventory is valid")

	local timberDefinition = ItemCatalog.timber_plank
	expect(timberDefinition ~= nil and timberDefinition.MaxStack == 50, "timber plank has a bounded stack definition")
	expect(timberDefinition ~= nil and timberDefinition.Tradeable, "construction supply is marked tradeable")
	expect(timberDefinition ~= nil and timberDefinition.MerchantGroup == "BuildingSupply", "construction supply belongs to the supply merchant group")
	expect(timberDefinition ~= nil and (timberDefinition :: any).Price == nil, "catalogue does not hard-code unreviewed prices")

	local inventoryWithTimber, addTimberError = InventoryPolicy.TryAdd(emptyInventory, "timber_plank", 12, ItemCatalog)
	expect(inventoryWithTimber ~= nil and addTimberError == nil, "valid item quantity can be added")
	assert(inventoryWithTimber ~= nil, "updated inventory must exist")
	expect(inventoryWithTimber.items.timber_plank == 12, "added item quantity is recorded")
	expect(emptyInventory.items.timber_plank == nil, "adding an item does not mutate the source inventory")

	local fullTimberStack, fullStackError = InventoryPolicy.TryAdd(inventoryWithTimber, "timber_plank", 38, ItemCatalog)
	expect(fullTimberStack ~= nil and fullStackError == nil, "adding up to the exact stack limit is allowed")
	assert(fullTimberStack ~= nil, "full stack inventory must exist")
	expect(fullTimberStack.items.timber_plank == 50, "stack reaches but does not exceed its configured limit")

	local overflowStack, overflowError = InventoryPolicy.TryAdd(fullTimberStack, "timber_plank", 1, ItemCatalog)
	expect(overflowStack == nil and overflowError ~= nil, "stack overflow is rejected")
	local unknownItem, unknownItemError = InventoryPolicy.TryAdd(emptyInventory, "unregistered_item", 1, ItemCatalog)
	expect(unknownItem == nil and unknownItemError ~= nil, "unknown item IDs are rejected")
	local fractionalItem, fractionalItemError = InventoryPolicy.TryAdd(emptyInventory, "stone_block", 1.5, ItemCatalog)
	expect(fractionalItem == nil and fractionalItemError ~= nil, "fractional item quantities are rejected")
	local negativeItem, negativeItemError = InventoryPolicy.TryAdd(emptyInventory, "stone_block", -1, ItemCatalog)
	expect(negativeItem == nil and negativeItemError ~= nil, "negative item quantities are rejected")
	local zeroItem, zeroItemError = InventoryPolicy.TryAdd(emptyInventory, "stone_block", 0, ItemCatalog)
	expect(zeroItem == nil and zeroItemError ~= nil, "zero item quantities are rejected")

	local reducedInventory, removeItemError = InventoryPolicy.TryRemove(inventoryWithTimber, "timber_plank", 5, ItemCatalog)
	expect(reducedInventory ~= nil and removeItemError == nil, "owned items can be removed")
	assert(reducedInventory ~= nil, "reduced inventory must exist")
	expect(reducedInventory.items.timber_plank == 7, "item removal subtracts the requested quantity")
	local insufficientInventory, insufficientItemError = InventoryPolicy.TryRemove(inventoryWithTimber, "timber_plank", 13, ItemCatalog)
	expect(insufficientInventory == nil and insufficientItemError ~= nil, "removing more than owned quantity is rejected")
	local invalidInventory, invalidInventoryError = InventoryPolicy.Validate({ items = { timber_plank = 51 } }, ItemCatalog)
	expect(invalidInventory == false and invalidInventoryError ~= nil, "loaded inventory above a stack cap fails validation")
	local unknownInventory, unknownInventoryError = InventoryPolicy.Validate({ items = { unknown_item = 1 } }, ItemCatalog)
	expect(unknownInventory == false and unknownInventoryError ~= nil, "loaded inventory with unknown IDs fails validation")

	print("[BTV tests] Construction supply catalogue and inventory policy rules passed.")
end

do
	-- NPC merchant rules are pure, bounded and idempotent; test prices are fixtures, not live balance values.
	local merchantProfile = PlayerProfileSchema.CreateDefault()
	merchantProfile.economy.aces = 100

	local purchasedProfile, purchaseError, purchaseOutcome = MerchantTransactionPolicy.TryPurchase(
		merchantProfile,
		"timber_plank",
		3,
		4,
		"merchant-buy-001",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(purchasedProfile ~= nil and purchaseError == nil and purchaseOutcome == "Applied", "valid NPC merchant purchase is applied")
	assert(purchasedProfile ~= nil, "purchased profile must exist")
	expect(purchasedProfile.economy.aces == 88, "purchase debits the exact server price")
	expect(purchasedProfile.inventory.items.timber_plank == 3, "purchase grants the requested item quantity")
	expect(merchantProfile.economy.aces == 100 and merchantProfile.inventory.items.timber_plank == nil, "purchase does not mutate the source profile")
	expect(#purchasedProfile.economy.recentTransactions == 1, "purchase records its durable idempotency entry")

	local repeatedPurchase, repeatedPurchaseError, repeatedPurchaseOutcome = MerchantTransactionPolicy.TryPurchase(
		purchasedProfile,
		"timber_plank",
		3,
		4,
		"merchant-buy-001",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(
		repeatedPurchase ~= nil and repeatedPurchaseError == nil and repeatedPurchaseOutcome == "AlreadyApplied",
		"exact duplicate purchase is reconciled without applying twice"
	)
	assert(repeatedPurchase ~= nil, "reconciled purchase profile must exist")
	expect(repeatedPurchase.economy.aces == 88 and repeatedPurchase.inventory.items.timber_plank == 3, "duplicate purchase cannot double debit or grant")

	local reusedPurchaseId, reusedPurchaseIdError = MerchantTransactionPolicy.TryPurchase(
		purchasedProfile,
		"timber_plank",
		2,
		4,
		"merchant-buy-001",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(reusedPurchaseId == nil and reusedPurchaseIdError ~= nil, "transaction ID reuse with a different payload is rejected")

	local insufficientPurchase, insufficientPurchaseError = MerchantTransactionPolicy.TryPurchase(
		merchantProfile,
		"timber_plank",
		26,
		4,
		"merchant-buy-insufficient",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(insufficientPurchase == nil and insufficientPurchaseError ~= nil, "purchase rejects insufficient Aces")

	local invalidPrice, invalidPriceError = MerchantTransactionPolicy.TryPurchase(
		merchantProfile,
		"timber_plank",
		1,
		0,
		"merchant-buy-zero",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(invalidPrice == nil and invalidPriceError ~= nil, "purchase rejects zero server prices")

	local invalidQuantity, invalidQuantityError = MerchantTransactionPolicy.TryPurchase(
		merchantProfile,
		"timber_plank",
		1.5,
		4,
		"merchant-buy-fractional",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(invalidQuantity == nil and invalidQuantityError ~= nil, "purchase rejects fractional quantities")

	local unknownPurchase, unknownPurchaseError = MerchantTransactionPolicy.TryPurchase(
		merchantProfile,
		"not_a_real_item",
		1,
		4,
		"merchant-buy-unknown",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(unknownPurchase == nil and unknownPurchaseError ~= nil, "purchase rejects unknown item IDs")

	local soldProfile, saleError, saleOutcome = MerchantTransactionPolicy.TrySell(
		purchasedProfile,
		"timber_plank",
		2,
		2,
		"merchant-sell-001",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(soldProfile ~= nil and saleError == nil and saleOutcome == "Applied", "valid NPC merchant sale is applied")
	assert(soldProfile ~= nil, "sold profile must exist")
	expect(soldProfile.economy.aces == 92, "sale credits the configured server buyback value")
	expect(soldProfile.inventory.items.timber_plank == 1, "sale removes the requested item quantity")

	local repeatedSale, repeatedSaleError, repeatedSaleOutcome = MerchantTransactionPolicy.TrySell(
		soldProfile,
		"timber_plank",
		2,
		2,
		"merchant-sell-001",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(repeatedSale ~= nil and repeatedSaleError == nil and repeatedSaleOutcome == "AlreadyApplied", "exact duplicate sale is reconciled without paying twice")
	assert(repeatedSale ~= nil, "reconciled sale profile must exist")
	expect(repeatedSale.economy.aces == 92 and repeatedSale.inventory.items.timber_plank == 1, "duplicate sale cannot double credit or remove")

	local insufficientSale, insufficientSaleError = MerchantTransactionPolicy.TrySell(
		soldProfile,
		"timber_plank",
		2,
		2,
		"merchant-sell-insufficient",
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		InventoryPolicy,
		ItemCatalog
	)
	expect(insufficientSale == nil and insufficientSaleError ~= nil, "sale rejects quantities the player does not own")

	print("[BTV tests] NPC merchant transaction and idempotency rules passed.")
end

do
	-- The server merchant coordinator binds trusted offers to durable profile saves.
	local merchantStore = FakeProfileStore.new()
	local serviceClock = 500
	local serviceAdapter = ProfilePersistenceAdapter.new({
		Store = merchantStore,
		ProfileSchema = PlayerProfileSchema,
		RankCatalog = CovenantRankCatalog,
		CompanionCatalog = CompanionCatalog,
		InventoryPolicy = InventoryPolicy,
		ItemCatalog = ItemCatalog,
		LeasePolicy = ProfileLeasePolicy,
		RecordPolicy = ProfileRecordPolicy,
		Clock = function()
			return serviceClock
		end,
		Wait = function(_seconds) end,
		GenerateToken = function()
			return "merchant-service-owner-token"
		end,
		Random = function()
			return 0
		end,
	})
	local serviceSession, serviceAcquireError = serviceAdapter:Acquire(901003)
	expect(serviceSession ~= nil and serviceAcquireError == nil, "merchant service obtains a profile through the persistence adapter")
	assert(serviceSession ~= nil, "merchant service session must exist")
	local fundedServiceProfile = serviceSession.profile
	fundedServiceProfile.economy.aces = 100
	local fundedServiceSave, fundedServiceSaveError = serviceAdapter:Save(901003, serviceSession.ownerToken, fundedServiceProfile, "merchant-service-seed-001")
	expect(fundedServiceSave ~= nil and fundedServiceSaveError == nil, "merchant service test profile is funded through a durable save")
	assert(fundedServiceSave ~= nil, "funded merchant service profile must exist")
	serviceSession.profile = fundedServiceSave.profile
	serviceSession.revision = fundedServiceSave.revision

	local serviceSessions = { [901003] = serviceSession }
	local merchantService = MerchantService.new({
		Offers = {
			building_supply = {
				BuyPrices = { timber_plank = 4 },
				SellPrices = { timber_plank = 2 },
			},
		},
		GetSession = function(targetPlayer)
			return serviceSessions[targetPlayer.UserId]
		end,
		PersistenceAdapter = serviceAdapter,
		TransactionPolicy = MerchantTransactionPolicy,
		ProfileSchema = PlayerProfileSchema,
		RankCatalog = CovenantRankCatalog,
		CompanionCatalog = CompanionCatalog,
		InventoryPolicy = InventoryPolicy,
		ItemCatalog = ItemCatalog,
		Clock = function()
			return serviceClock
		end,
		MinimumRequestIntervalSeconds = 0.1,
	})
	local merchantPlayer = { UserId = 901003 }
	local servicePurchase, servicePurchaseError = merchantService:Purchase(merchantPlayer, "building_supply", "timber_plank", 3, "service-buy-0001")
	expect(servicePurchase ~= nil and servicePurchaseError == nil, "merchant service commits a purchase using server-owned prices")
	assert(servicePurchase ~= nil, "merchant service purchase receipt must exist")
	expect(servicePurchase.balance == 88 and servicePurchase.acesDelta == -12, "merchant service returns the committed debit")
	expect(merchantStore:Get("player:901003").profile.inventory.items.timber_plank == 3, "merchant service persists the granted inventory")

	local throttledPurchase, throttledPurchaseError = merchantService:Purchase(merchantPlayer, "building_supply", "timber_plank", 1, "service-buy-throttle")
	expect(throttledPurchase == nil and throttledPurchaseError ~= nil, "merchant service rate-limits rapid requests")

	serviceClock += 1
	local duplicateServicePurchase, duplicateServicePurchaseError = merchantService:Purchase(merchantPlayer, "building_supply", "timber_plank", 3, "service-buy-0001")
	expect(duplicateServicePurchase ~= nil and duplicateServicePurchaseError == nil, "merchant service reconciles duplicate request IDs")
	assert(duplicateServicePurchase ~= nil, "duplicate merchant receipt must exist")
	expect(duplicateServicePurchase.outcome == "AlreadyApplied" and duplicateServicePurchase.balance == 88, "duplicate request does not debit twice")

	serviceClock += 1
	local conflictingRequest, conflictingRequestError = merchantService:Purchase(merchantPlayer, "building_supply", "timber_plank", 2, "service-buy-0001")
	expect(conflictingRequest == nil and conflictingRequestError ~= nil, "merchant service rejects request ID reuse with a changed payload")

	serviceClock += 1
	local unknownMerchant, unknownMerchantError = merchantService:Purchase(merchantPlayer, "unregistered_merchant", "timber_plank", 1, "service-buy-0002")
	expect(unknownMerchant == nil and unknownMerchantError ~= nil, "merchant service rejects unknown merchant IDs")

	serviceClock += 1
	local unofferedItem, unofferedItemError = merchantService:Purchase(merchantPlayer, "building_supply", "stone_block", 1, "service-buy-0003")
	expect(unofferedItem == nil and unofferedItemError ~= nil, "merchant service rejects items not in the server offer table")

	serviceClock += 1
	merchantStore:QueueFailure("AfterCommit", "simulated response loss after durable commit")
	local ambiguousServicePurchase, ambiguousServicePurchaseError = merchantService:Purchase(merchantPlayer, "building_supply", "timber_plank", 1, "service-buy-0004")
	expect(ambiguousServicePurchase ~= nil and ambiguousServicePurchaseError == nil, "merchant service recovers an ambiguous committed purchase")
	assert(ambiguousServicePurchase ~= nil, "ambiguous merchant receipt must exist")
	expect(ambiguousServicePurchase.outcome == "AlreadyApplied", "ambiguous save retry is reconciled by the profile adapter")
	expect(ambiguousServicePurchase.balance == 84, "ambiguous purchase is reflected exactly once")

	serviceClock += 1
	local serviceSale, serviceSaleError = merchantService:Sell(merchantPlayer, "building_supply", "timber_plank", 2, "service-sell-0001")
	expect(serviceSale ~= nil and serviceSaleError == nil, "merchant service commits a sale")
	assert(serviceSale ~= nil, "merchant sale receipt must exist")
	expect(serviceSale.balance == 88 and serviceSale.acesDelta == 4, "merchant sale credits the configured buyback value")
	expect(merchantStore:Get("player:901003").profile.inventory.items.timber_plank == 2, "merchant service persists the sale inventory delta")

	local serviceReleased, serviceReleaseError = serviceAdapter:Release(901003, serviceSession.ownerToken)
	expect(serviceReleased and serviceReleaseError == nil, "merchant service test releases its profile lease")
	print("[BTV tests] Server merchant service, durable saves and recovery passed.")
end

do
	-- Parcel ownership and construction placement are server-verifiable, bounded and revisioned.
	local emptyParcel, parcelCreateError = PropertyPolicy.CreateState("ridgeview_residential_01", PropertyCatalog)
	expect(emptyParcel ~= nil and parcelCreateError == nil, "curated residential parcel can be initialized")
	assert(emptyParcel ~= nil, "parcel state must exist")
	local emptyParcelValid, emptyParcelError = ConstructionPlacementPolicy.ValidateParcel(emptyParcel, BuildModuleCatalog, PropertyPolicy)
	expect(emptyParcelValid and emptyParcelError == nil, "empty parcel satisfies construction invariants")

	local claimedParcel, claimError = PropertyPolicy.TryClaim(emptyParcel, 901004)
	expect(claimedParcel ~= nil and claimError == nil, "unclaimed residential parcel can be claimed")
	assert(claimedParcel ~= nil, "claimed parcel must exist")
	expect(claimedParcel.ownerUserId == 901004 and claimedParcel.revision == 1, "parcel claim records its owner and increments revision")
	expect(emptyParcel.ownerUserId == nil and emptyParcel.revision == 0, "claim does not mutate the source parcel")

	local competingClaim, competingClaimError = PropertyPolicy.TryClaim(claimedParcel, 901005)
	expect(competingClaim == nil and competingClaimError ~= nil, "a second player cannot claim an owned parcel")
	local invalidClaim, invalidClaimError = PropertyPolicy.TryClaim(emptyParcel, 0)
	expect(invalidClaim == nil and invalidClaimError ~= nil, "parcel claim rejects invalid user IDs")

	local wrongOwnerPlacement, wrongOwnerPlacementError =
		ConstructionPlacementPolicy.TryPlace(claimedParcel, 901005, 1, "foundation_tile", "foundation-wrong-owner", 0, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(wrongOwnerPlacement == nil and wrongOwnerPlacementError ~= nil, "non-owner cannot place construction modules")

	local foundationParcel, foundationError =
		ConstructionPlacementPolicy.TryPlace(claimedParcel, 901004, 1, "foundation_tile", "foundation-001", 0, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(foundationParcel ~= nil and foundationError == nil, "approved foundation module can be placed")
	assert(foundationParcel ~= nil, "foundation parcel must exist")
	expect(foundationParcel.revision == 2 and #foundationParcel.objects == 1, "placement increments revision and records one module")

	local wallParcel, wallError = ConstructionPlacementPolicy.TryPlace(foundationParcel, 901004, 2, "wall_panel", "wall-001", 0, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(wallParcel ~= nil and wallError == nil, "wall module can be placed over supporting foundation")
	assert(wallParcel ~= nil, "wall parcel must exist")

	local roofParcel, roofError = ConstructionPlacementPolicy.TryPlace(wallParcel, 901004, 3, "roof_panel", "roof-001", 0, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(roofParcel ~= nil and roofError == nil, "roof module can be placed over supporting wall")
	assert(roofParcel ~= nil, "roof parcel must exist")

	local chairParcel, chairError = ConstructionPlacementPolicy.TryPlace(roofParcel, 901004, 4, "chair", "chair-001", 0, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(chairParcel ~= nil and chairError == nil, "furniture module can be placed over foundation")
	assert(chairParcel ~= nil, "chair parcel must exist")

	local overlapPlacement, overlapError = ConstructionPlacementPolicy.TryPlace(chairParcel, 901004, 5, "wall_panel", "wall-overlap", 1, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(overlapPlacement == nil and overlapError ~= nil, "overlapping modules on the same layer are rejected")

	local unsupportedPlacement, unsupportedError =
		ConstructionPlacementPolicy.TryPlace(chairParcel, 901004, 5, "wall_panel", "wall-floating", 4, 0, 0, BuildModuleCatalog, PropertyPolicy)
	expect(unsupportedPlacement == nil and unsupportedError ~= nil, "unsupported wall placement is rejected")

	local outOfBoundsPlacement, outOfBoundsError =
		ConstructionPlacementPolicy.TryPlace(chairParcel, 901004, 5, "wall_panel", "wall-outside", 11, 11, 0, BuildModuleCatalog, PropertyPolicy)
	expect(outOfBoundsPlacement == nil and outOfBoundsError ~= nil, "placement beyond parcel bounds is rejected")

	local duplicateObjectId, duplicateObjectIdError =
		ConstructionPlacementPolicy.TryPlace(chairParcel, 901004, 5, "chair", "chair-001", 2, 2, 0, BuildModuleCatalog, PropertyPolicy)
	expect(duplicateObjectId == nil and duplicateObjectIdError ~= nil, "duplicate construction object IDs are rejected")

	local stalePlacement, stalePlacementError = ConstructionPlacementPolicy.TryPlace(chairParcel, 901004, 4, "chair", "chair-stale", 2, 2, 0, BuildModuleCatalog, PropertyPolicy)
	expect(stalePlacement == nil and stalePlacementError ~= nil, "stale parcel revisions cannot place modules")

	local removeSupport, removeSupportError = ConstructionPlacementPolicy.TryRemove(chairParcel, 901004, 5, "foundation-001", BuildModuleCatalog, PropertyPolicy)
	expect(removeSupport == nil and removeSupportError ~= nil, "supporting foundation cannot be removed while dependent modules remain")

	local removedChair, removeChairError = ConstructionPlacementPolicy.TryRemove(chairParcel, 901004, 5, "chair-001", BuildModuleCatalog, PropertyPolicy)
	expect(removedChair ~= nil and removeChairError == nil, "owner can remove an unreferenced furniture module")
	assert(removedChair ~= nil, "parcel after chair removal must exist")
	local removedRoof, removeRoofError = ConstructionPlacementPolicy.TryRemove(removedChair, 901004, 6, "roof-001", BuildModuleCatalog, PropertyPolicy)
	expect(removedRoof ~= nil and removeRoofError == nil, "owner can remove the roof before its supporting wall")
	assert(removedRoof ~= nil, "parcel after roof removal must exist")
	local removedWall, removeWallError = ConstructionPlacementPolicy.TryRemove(removedRoof, 901004, 7, "wall-001", BuildModuleCatalog, PropertyPolicy)
	expect(removedWall ~= nil and removeWallError == nil, "owner can remove wall after roof")
	assert(removedWall ~= nil, "parcel after wall removal must exist")
	local removedFoundation, removeFoundationError = ConstructionPlacementPolicy.TryRemove(removedWall, 901004, 8, "foundation-001", BuildModuleCatalog, PropertyPolicy)
	expect(removedFoundation ~= nil and removeFoundationError == nil, "owner can clear the final foundation")
	assert(removedFoundation ~= nil, "empty claimed parcel must exist")

	local releasedParcel, releaseParcelError = PropertyPolicy.TryRelease(removedFoundation, 901004, 9)
	expect(releasedParcel ~= nil and releaseParcelError == nil, "owner can release a cleared parcel")
	assert(releasedParcel ~= nil, "released parcel must exist")
	expect(releasedParcel.ownerUserId == nil and releasedParcel.revision == 10, "release clears ownership and increments revision")

	local malformedModuleParcel = table.clone(claimedParcel)
	malformedModuleParcel.objects = {
		{ id = "bad-module", moduleId = "unapproved_module", x = 0, z = 0, layer = 0, rotation = 0 },
	}
	local malformedModuleValid, malformedModuleError = ConstructionPlacementPolicy.ValidateParcel(malformedModuleParcel, BuildModuleCatalog, PropertyPolicy)
	expect(malformedModuleValid == false and malformedModuleError ~= nil, "parcel validation rejects unapproved modules")

	local sparseParcel = table.clone(claimedParcel)
	sparseParcel.objects = {
		[2] = { id = "sparse-object", moduleId = "foundation_tile", x = 0, z = 0, layer = 0, rotation = 0 },
	}
	local sparseParcelValid, sparseParcelError =
		ConstructionPlacementPolicy.ValidateParcel(sparseParcel, BuildModuleCatalog, PropertyPolicy)
	expect(sparseParcelValid == false and sparseParcelError ~= nil, "parcel validation rejects sparse object arrays")


	print("[BTV tests] Property ownership and construction placement rules passed.")
end
