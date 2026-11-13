--!strict
-- Headless tests for consent-gated Ridgeview testimony disclosure.
-- Run from the roblox directory with: lune run tests/settlement.spec.luau

local SettlementPolicy = require("../src/shared/RidgeviewSettlementPolicy")

local function expect(condition: boolean, message: string)
	if not condition then
		error("[BTV settlement test failed] " .. message)
	end
end

local state = SettlementPolicy.NewState()
expect(state.wrenTestimonyRecorded == false, "Wren testimony begins unrecorded")
expect(state.wrenTestimonyShareable == false, "Wren testimony begins private")
expect(not SettlementPolicy.CanDiscussWrenWithPike(state), "Pike cannot access unrecorded testimony")

local prematurePermission = SettlementPolicy.SetWrenSharePermission(state, true)
expect(prematurePermission == nil, "permission cannot be granted before testimony is recorded")

state = SettlementPolicy.RecordWrenTestimony(state)
expect(state.wrenTestimonyRecorded, "Wren testimony can be recorded")
expect(not state.wrenTestimonyShareable, "recording alone does not authorize sharing")
expect(not SettlementPolicy.CanDiscussWrenWithPike(state), "Pike remains locked after recording without permission")

local invalidPermission = SettlementPolicy.SetWrenSharePermission(state, "yes")
expect(invalidPermission == nil, "non-boolean permission is rejected")

local privateState = SettlementPolicy.SetWrenSharePermission(state, false)
expect(privateState ~= nil, "explicit private choice is accepted")
assert(privateState ~= nil, "private state must exist")
expect(not SettlementPolicy.CanDiscussWrenWithPike(privateState), "explicitly private testimony remains unavailable to Pike")

local sharedState = SettlementPolicy.SetWrenSharePermission(state, true)
expect(sharedState ~= nil, "explicit share permission is accepted")
assert(sharedState ~= nil, "shareable state must exist")
expect(SettlementPolicy.CanDiscussWrenWithPike(sharedState), "Pike branch unlocks only after recording and explicit permission")

local reRecorded = SettlementPolicy.RecordWrenTestimony(sharedState)
expect(reRecorded.wrenTestimonyRecorded, "re-recorded testimony remains recorded")
expect(not reRecorded.wrenTestimonyShareable, "re-recording clears prior permission until reconfirmed")
expect(not SettlementPolicy.CanDiscussWrenWithPike(reRecorded), "Pike branch relocks when permission is not current")

local admitted = SettlementPolicy.RecordPikeAdmission(sharedState)
expect(admitted.pikeAdmissionRecorded, "Pike's limited admission can be recorded after the authorized branch")
expect(not state.pikeAdmissionRecorded, "policy transformations do not mutate prior state")

print("[BTV settlement tests] PASS — Wren testimony disclosure requires recording and explicit permission.")
