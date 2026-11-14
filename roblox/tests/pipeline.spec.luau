--!strict
-- Offline regression checks for the BTV Roblox runtime testing pipeline.
-- Run from the roblox directory with: lune run tests/pipeline.spec.luau
--
-- These checks keep the pipeline honest without a Studio licence: they prove
-- that the test place mapping still matches the repository layout, that the
-- engine harness still loads and still registers its expected tests, and that
-- the automation entry points are present and reference the right files.
--
-- They do NOT prove anything about the engine. That is what the Studio runtime
-- job and Open Cloud Luau Execution are for.

local fs = require("@lune/fs")

local EngineTests = require("./engine/EngineTests")

local function expect(condition: boolean, message: string)
	if not condition then
		error("[BTV pipeline test failed] " .. message)
	end
end

-- Lune has no `io` global; the filesystem API lives in @lune/fs.
local function readFile(path: string): string?
	if not fs.isFile(path) then
		return nil
	end
	return fs.readFile(path)
end

local function fileExists(path: string): boolean
	return fs.isFile(path)
end

local function directoryExists(path: string): boolean
	return fs.isDir(path)
end

--=============================================================================
-- The engine harness loads outside the engine and still registers its tests
--=============================================================================

local expectedTests = {
	"bootstrap_remotes",
	"world_scenes_exist",
	"temple_structure",
	"ridgeview_arrival_marker",
	"ridgeview_tree_trunks_are_upright",
	"ridgeview_departure_sign_faces_the_player",
	"archive_prompt_is_shared",
	"companion_actor_spawns",
	"mission_service_state",
	"client_hud_present",
}

local names = EngineTests.TestNames()
expect(#names == #expectedTests, "engine harness registers " .. #expectedTests .. " tests, found " .. #names)
for _, expected in expectedTests do
	local found = false
	for _, name in names do
		if name == expected then
			found = true
			break
		end
	end
	expect(found, "engine harness is missing the test: " .. expected)
end

-- A test name that does not exist must fail cleanly rather than error.
local unknownOk, unknownMessage = EngineTests.RunOne("no_such_test")
expect(unknownOk == false, "an unknown engine test name is rejected")
expect(type(unknownMessage) == "string", "an unknown engine test name returns a message")

--=============================================================================
-- The Rojo test mapping matches the repository layout
--=============================================================================

local mapping = readFile("test.project.json")
expect(mapping ~= nil, "test.project.json exists")

if mapping ~= nil then
	for _, path in { '"src/shared"', '"src/server"', '"src/client"', '"tests/engine"' } do
		expect(string.find(mapping, path, 1, true) ~= nil, "test.project.json maps " .. path)
	end
	-- The harness must land in ServerStorage so the engine task can require it.
	expect(string.find(mapping, "ServerStorage", 1, true) ~= nil, "test.project.json maps ServerStorage")
	expect(string.find(mapping, "BTVTestKit", 1, true) ~= nil, "test.project.json maps the TestKit")
end

for _, required in { "src/shared", "src/server", "src/client", "tests/engine" } do
	expect(directoryExists(required), "the mapped directory exists on disk: " .. required)
end
expect(fileExists("tests/engine/EngineTests.luau"), "the engine harness exists on disk")

--=============================================================================
-- The automation entry points exist and point at the right things
--=============================================================================

expect(fileExists("tools/engine-task.luau"), "the engine task entry point exists")
expect(fileExists("tools/opencloud/run_luau_task.py"), "the Open Cloud client exists")
expect(fileExists("tools/studio/run-engine-tests.ps1"), "the Studio runner exists")
expect(fileExists("ci/roblox-studio-validation.yml"), "the Studio CI workflow source exists")
expect(fileExists("ci/install-studio-workflow.sh"), "the workflow installer exists")

local engineTask = readFile("tools/engine-task.luau")
expect(engineTask ~= nil, "the engine task entry point is readable")
if engineTask ~= nil then
	expect(string.find(engineTask, "BTVTestKit", 1, true) ~= nil, "the engine task requires the TestKit")
	expect(string.find(engineTask, "RunAll", 1, true) ~= nil, "the engine task runs the whole suite")
end

local openCloud = readFile("tools/opencloud/run_luau_task.py")
expect(openCloud ~= nil, "the Open Cloud client is readable")
if openCloud ~= nil then
	expect(string.find(openCloud, "luau-execution-session-tasks", 1, true) ~= nil, "the Open Cloud client calls the Luau Execution endpoint")
	expect(string.find(openCloud, "x-api-key", 1, true) ~= nil, "the Open Cloud client authenticates with a header")
	-- The key must never be written to disk or echoed.
	expect(string.find(openCloud, "print(api_key", 1, true) == nil, "the Open Cloud client never prints the API key")
	expect(string.find(openCloud, "ROBLOX_API_KEY", 1, true) ~= nil, "the Open Cloud client reads the key from the environment")
end

local workflow = readFile("ci/roblox-studio-validation.yml")
expect(workflow ~= nil, "the Studio workflow source is readable")
if workflow ~= nil then
	expect(string.find(workflow, "windows-latest", 1, true) ~= nil, "the Studio workflow runs on a Windows runner")
	expect(string.find(workflow, "run-in-roblox", 1, true) ~= nil, "the Studio workflow installs and drives run-in-roblox")
	expect(string.find(workflow, "test.project.json", 1, true) ~= nil, "the Studio workflow builds the test place")
	expect(string.find(workflow, "tools/engine-task.luau", 1, true) ~= nil, "the Studio workflow runs the engine task")
	expect(string.find(workflow, "contents: read", 1, true) ~= nil, "the Studio workflow requests read-only repository permissions")
	expect(string.find(workflow, "contents: write", 1, true) == nil, "the Studio workflow does not request write permissions")
end

--=============================================================================
-- The offline suite must keep its own coverage contract
--=============================================================================

expect(fileExists("tests/foundation.spec.luau"), "the foundation suite exists")
expect(fileExists("tests/settlement.spec.luau"), "the settlement suite exists")
expect(fileExists("tests/ridgeview_investigation.spec.luau"), "the Ridgeview investigation suite exists")

print("[BTV pipeline tests] Runtime testing pipeline structure and engine harness registry passed.")
