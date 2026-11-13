--!strict
-- Consent and disclosure policy for the Ridgeview Wren/Pike conversation.
-- The server owns this state. Recording testimony never implies permission to share it.

local RidgeviewSettlementPolicy = {}

export type State = {
	wrenTestimonyRecorded: boolean,
	wrenTestimonyShareable: boolean,
	pikeAdmissionRecorded: boolean,
}

function RidgeviewSettlementPolicy.NewState(): State
	return {
		wrenTestimonyRecorded = false,
		wrenTestimonyShareable = false,
		pikeAdmissionRecorded = false,
	}
end

function RidgeviewSettlementPolicy.RecordWrenTestimony(state: State): State
	local updated = table.clone(state)
	updated.wrenTestimonyRecorded = true
	-- Re-recording or importing testimony must never inherit old permission.
	updated.wrenTestimonyShareable = false
	return updated
end

function RidgeviewSettlementPolicy.SetWrenSharePermission(state: State, permission: unknown): (State?, string?)
	if not state.wrenTestimonyRecorded then
		return nil, "Wren testimony must be recorded before permission can be set."
	end
	if typeof(permission) ~= "boolean" then
		return nil, "Sharing permission must be an explicit boolean."
	end

	local updated = table.clone(state)
	updated.wrenTestimonyShareable = permission
	return updated, nil
end

function RidgeviewSettlementPolicy.CanDiscussWrenWithPike(state: State): boolean
	return state.wrenTestimonyRecorded and state.wrenTestimonyShareable
end

function RidgeviewSettlementPolicy.RecordPikeAdmission(state: State): (State?, string?)
	if not RidgeviewSettlementPolicy.CanDiscussWrenWithPike(state) then
		return nil, "Pike's response requires recorded testimony and explicit sharing permission."
	end
	local updated = table.clone(state)
	updated.pikeAdmissionRecorded = true
	return updated, nil
end

return table.freeze(RidgeviewSettlementPolicy)
