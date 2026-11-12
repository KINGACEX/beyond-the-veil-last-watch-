--!strict
-- Headless regression checks for pure BTV Roblox rules.
-- Run from the roblox directory with: lune run tests/foundation.spec.luau

local MissionService = require("../src/server/Services/MissionService")
local CompanionCatalog = require("../src/shared/CompanionCatalog")
local CompanionOwnershipPolicy = require("../src/server/Services/CompanionOwnershipPolicy")
local CompanionRigContract = require("../src/shared/CompanionRigContract")
local ArchiveService = require("../src/server/Services/ArchiveService")

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
expect(string.find(report.status, "evidence pending", 1, true) ~= nil, "report does not invent evidence")

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
