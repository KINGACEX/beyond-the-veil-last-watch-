--!strict
-- Deterministic in-memory stand-in for the small DataStore surface used by
-- profile policy tests. This module is test infrastructure only; it must never
-- be wired into live player sessions.
local FakeProfileStore = {}
FakeProfileStore.__index = FakeProfileStore

type Failure = {
	stage: string,
	message: string,
}

local function cloneValue(value: any): any
	if typeof(value) ~= "table" then
		return value
	end

	local copy = {}
	for key, item in value do
		copy[cloneValue(key)] = cloneValue(item)
	end
	return copy
end

function FakeProfileStore.new()
	return setmetatable({
		records = {},
		updateCallCount = 0,
		callbackCallCount = 0,
		failures = {},
		callbackReplays = {},
	}, FakeProfileStore)
end

function FakeProfileStore:Set(key: string, value: any)
	self.records[key] = cloneValue(value)
end

function FakeProfileStore:Get(key: string): any
	return cloneValue(self.records[key])
end

function FakeProfileStore:QueueFailure(stage: string, message: string)
	assert(stage == "BeforeCallback" or stage == "AfterCommit", "unknown fake failure stage")
	table.insert(self.failures, {
		stage = stage,
		message = message,
	} :: Failure)
end

-- Simulates another writer winning between callback executions. The first
-- callback result is discarded; the callback is invoked again with the newer
-- stored value, matching the important retry property of UpdateAsync.
function FakeProfileStore:QueueCallbackReplay(key: string, competingRecord: any)
	table.insert(self.callbackReplays, {
		key = key,
		record = cloneValue(competingRecord),
	})
end

function FakeProfileStore:UpdateAsync(key: string, transform: (any) -> any): (any?, string?)
	self.updateCallCount += 1

	local failure = self.failures[1]
	if failure ~= nil and failure.stage == "BeforeCallback" then
		table.remove(self.failures, 1)
		return nil, failure.message
	end

	self.callbackCallCount += 1
	local current = cloneValue(self.records[key])
	local proposed = transform(cloneValue(current))

	local replay = self.callbackReplays[1]
	if replay ~= nil and replay.key == key then
		table.remove(self.callbackReplays, 1)
		self.records[key] = cloneValue(replay.record)
		current = cloneValue(self.records[key])
		self.callbackCallCount += 1
		proposed = transform(cloneValue(current))
	end

	if proposed ~= nil then
		self.records[key] = cloneValue(proposed)
	end

	if failure ~= nil and failure.stage == "AfterCommit" then
		table.remove(self.failures, 1)
		return nil, failure.message
	end

	if proposed == nil then
		return nil, nil
	end
	return cloneValue(self.records[key]), nil
end

return table.freeze(FakeProfileStore)
