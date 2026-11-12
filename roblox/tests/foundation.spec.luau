--!strict
-- Headless regression checks for pure BTV Roblox rules.
-- Run from the roblox directory with: lune run tests/foundation.spec.luau

local MissionService = require("../src/server/Services/MissionService")
local CompanionCatalog = require("../src/shared/CompanionCatalog")
local CompanionOwnershipPolicy = require("../src/server/Services/CompanionOwnershipPolicy")

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


-- Server ownership policy: default access is isolated, explicit and fail-closed.
local firstSessionOwnership = CompanionOwnershipPolicy.CreateDefaultOwnership()
local secondSessionOwnership = CompanionOwnershipPolicy.CreateDefaultOwnership()
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
