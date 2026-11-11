--!strict
-- Headless regression checks for pure BTV Roblox rules.
-- Run from the roblox directory with: lune run tests/foundation.spec.luau

local MissionService = require("../src/server/Services/MissionService")
local CompanionCatalog = require("../src/shared/CompanionCatalog")

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
expect(initial.phase == "communion_context", "mission starts in Communion context")
expect(initial.sequenceIndex == 1, "initial mission index is one")
expect(initial.objective == "Enter the sanctuary", "initial objective is correct")

local skipped = MissionService.Advance(player :: any, "communion_context", "report_accessed")
expect(skipped == false, "mission cannot skip the Covenant alert phase")

local advanced, alert = MissionService.Advance(player :: any, "communion_context", "covenant_alert")
expect(advanced, "sanctuary transition advances to Covenant alert")
expect(alert ~= nil and alert.sequenceIndex == 2, "Covenant alert is sequence two")

local repeated = MissionService.Advance(player :: any, "communion_context", "covenant_alert")
expect(repeated == false, "stale phase cannot advance twice")

local reportAdvanced, report = MissionService.Advance(player :: any, "covenant_alert", "report_accessed")
expect(reportAdvanced, "Scout Report access advances the final opening phase")
expect(report ~= nil and report.sequenceIndex == 3, "report phase is sequence three")
expect(string.find(report.status, "evidence pending", 1, true) ~= nil, "report does not invent evidence")

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

print("[BTV tests] Foundation rules passed.")
