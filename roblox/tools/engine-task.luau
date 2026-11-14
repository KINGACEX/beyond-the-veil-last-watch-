--!strict
-- BTV Roblox engine test entry point.
--
-- This chunk is executed INSIDE a running Roblox place by:
--   * run-in-roblox (Studio Play mode, local place file)  — roblox/tools/studio/run-engine-tests.ps1
--   * Open Cloud Luau Execution                          — roblox/tools/opencloud/run_luau_task.py
--
-- It requires the engine test harness from the place's ServerStorage and
-- returns the structured result so the runner can assert on it.
--
-- The harness is mapped into ServerStorage by roblox/test.project.json.

local serverStorage = game:GetService("ServerStorage")
local testKit = serverStorage:FindFirstChild("BTVTestKit")
if testKit == nil then
	return {
		passed = 0,
		failed = 1,
		total = 1,
		results = {
			{
				name = "testkit_present",
				ok = false,
				message = "ServerStorage.BTVTestKit is missing. Build with test.project.json, not default.project.json.",
			},
		},
	}
end

local engineTests = require(testKit:FindFirstChild("EngineTests"))
local summary = engineTests.RunAll(30)

print(engineTests.Format(summary))
return summary
