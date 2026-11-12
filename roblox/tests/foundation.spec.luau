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

local function expect(condition: boolean, message: string)
	if not condition then
		error("[BTV test failed] " .. message)
	end
end

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

-- Curiosity Archive discoveries are server-owned, session-only and non-economic.
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

-- Versioned profile schema validation is pure and does not enable DataStore writes.
local defaultProfile = PlayerProfileSchema.CreateDefault()
local validProfile, validProfileReason = PlayerProfileSchema.Validate(defaultProfile, CovenantRankCatalog, CompanionCatalog)
expect(validProfile, "new versioned profile passes schema validation")
expect(validProfileReason == nil, "valid profile has no validation error")
expect(defaultProfile.schemaVersion == 1, "new profile uses the current schema version")
expect(defaultProfile.progression.covenantRank == "Recruit", "new profile starts at Recruit")
expect(defaultProfile.companions.owned.ember == true, "new profile owns Ember")
expect(defaultProfile.companions.owned.fox == true, "new profile owns Fox")
expect(defaultProfile.companions.owned.owl == true, "new profile owns Owl")
expect(defaultProfile.companions.owned.horse == true, "new profile owns Horse")
expect(defaultProfile.companions.owned.eagle ~= true, "new profile does not grant premium candidates")

local unsupportedProfile = table.clone(defaultProfile)
unsupportedProfile.schemaVersion = 99
local unsupportedValid = PlayerProfileSchema.Validate(unsupportedProfile, CovenantRankCatalog, CompanionCatalog)
expect(not unsupportedValid, "unsupported profile schema is rejected")

local unknownRankProfile = table.clone(defaultProfile)
unknownRankProfile.progression = table.clone(defaultProfile.progression)
unknownRankProfile.progression.covenantRank = "Supreme Commander"
local unknownRankValid = PlayerProfileSchema.Validate(unknownRankProfile, CovenantRankCatalog, CompanionCatalog)
expect(not unknownRankValid, "unknown Covenant rank is rejected")

local negativeBalanceProfile = table.clone(defaultProfile)
negativeBalanceProfile.economy = table.clone(defaultProfile.economy)
negativeBalanceProfile.economy.aces = -1
local negativeBalanceValid = PlayerProfileSchema.Validate(negativeBalanceProfile, CovenantRankCatalog, CompanionCatalog)
expect(not negativeBalanceValid, "negative currency balance is rejected")

local fractionalBalanceProfile = table.clone(defaultProfile)
fractionalBalanceProfile.economy = table.clone(defaultProfile.economy)
fractionalBalanceProfile.economy.covenantCredits = 1.5
local fractionalBalanceValid = PlayerProfileSchema.Validate(fractionalBalanceProfile, CovenantRankCatalog, CompanionCatalog)
expect(not fractionalBalanceValid, "fractional currency balance is rejected")

local forgedPremiumProfile = table.clone(defaultProfile)
forgedPremiumProfile.companions = table.clone(defaultProfile.companions)
forgedPremiumProfile.companions.owned = table.clone(defaultProfile.companions.owned)
forgedPremiumProfile.companions.owned.eagle = true
local forgedPremiumValid = PlayerProfileSchema.Validate(forgedPremiumProfile, CovenantRankCatalog, CompanionCatalog)
expect(not forgedPremiumValid, "profile cannot forge premium companion ownership")

local unownedEquippedProfile = table.clone(defaultProfile)
unownedEquippedProfile.companions = table.clone(defaultProfile.companions)
unownedEquippedProfile.companions.equipped = "eagle"
local unownedEquippedValid = PlayerProfileSchema.Validate(unownedEquippedProfile, CovenantRankCatalog, CompanionCatalog)
expect(not unownedEquippedValid, "profile cannot equip an unowned companion")

local malformedEventsProfile = table.clone(defaultProfile)
malformedEventsProfile.progression = table.clone(defaultProfile.progression)
malformedEventsProfile.progression.completedMissionIds = { [1] = "mission_a", [3] = "mission_c" }
local malformedEventsValid = PlayerProfileSchema.Validate(malformedEventsProfile, CovenantRankCatalog, CompanionCatalog)
expect(not malformedEventsValid, "sparse progression event lists are rejected")

local duplicateEventsProfile = table.clone(defaultProfile)
duplicateEventsProfile.progression = table.clone(defaultProfile.progression)
duplicateEventsProfile.progression.completedEvaluations = { "evaluation_001", "evaluation_001" }
local duplicateEventsValid = PlayerProfileSchema.Validate(duplicateEventsProfile, CovenantRankCatalog, CompanionCatalog)
expect(not duplicateEventsValid, "duplicate evaluation IDs are rejected")

defaultProfile.companions.owned.fox = false
local independentDefault = PlayerProfileSchema.CreateDefault()
expect(independentDefault.companions.owned.fox == true, "mutating one profile cannot mutate future default profiles")

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

-- Atomic DataStore callback transformations preserve ownership and reject stale writes.
local acquiredRecord, acquiredRecordError = ProfileRecordPolicy.TryAcquire(
	nil,
	"server-A",
	100,
	60,
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	ProfileLeasePolicy
)
expect(acquiredRecord ~= nil and acquiredRecordError == nil, "new profile record can be initialized with a lease")
assert(acquiredRecord ~= nil, "acquired profile record must exist")
expect(acquiredRecord.profile.progression.covenantRank == "Recruit", "new record starts at Recruit")
expect(acquiredRecord.profile.revision == 0, "new record starts at revision zero")

local occupiedRecord, occupiedError = ProfileRecordPolicy.TryAcquire(
	acquiredRecord,
	"server-B",
	120,
	60,
	PlayerProfileSchema,	CovenantRankCatalog,
	CompanionCatalog,
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
	ProfileLeasePolicy
)
expect(invalidOperation == nil and invalidOperationError ~= nil, "empty save operation ID is rejected")

local reacquiredAfterSave, reacquireAfterSaveError = ProfileRecordPolicy.TryAcquire(
	savedRecord,
	"server-B",
	200,
	60,
	PlayerProfileSchema,
	CovenantRankCatalog,
	CompanionCatalog,
	ProfileLeasePolicy
)
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
	ProfileLeasePolicy
)
expect(malformedSaveMarker == nil and malformedSaveMarkerError ~= nil, "malformed save-operation marker fails closed")
print("[BTV tests] Profile record policy rules passed.")


-- Fake storage exercises UpdateAsync callback replay and ambiguous write outcomes.
local fakeStore = FakeProfileStore.new()
local profileKey = "player:901001"
fakeStore:QueueCallbackReplay(profileKey, acquiredRecord)
local replayedAcquire, replayedAcquireError = fakeStore:UpdateAsync(profileKey, function(existing)
	local nextRecord, policyError = ProfileRecordPolicy.TryAcquire(
		existing,
		"server-B",
		120,
		60,
		PlayerProfileSchema,
		CovenantRankCatalog,
		CompanionCatalog,
		ProfileLeasePolicy
	)
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

// Fake store isolation: callers cannot mutate durable records through aliases,
// and a cancelled transform cannot alter the stored value.
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
