--!strict
-- BTV Roblox engine test harness.
--
-- These tests execute INSIDE a real Roblox place. They are the layer that offline
-- (Lune) tests cannot reach: they touch the DataModel, the instances the server
-- scripts actually build, ProximityPrompt behaviour, replication targets and the
-- physical geometry the players stand on.
--
-- Design rules:
--   * No engine access at require time. Every `game:` reference happens inside a
--     test function, so this module can also be loaded by Lune for offline checks.
--   * Each test returns (ok: boolean, message: string).
--   * A failing test never aborts the run; RunAll collects every result.
--   * Nothing here mutates gameplay state or calls a RemoteEvent.

local EngineTests = {}

export type TestResult = {
	name: string,
	ok: boolean,
	message: string,
}

export type RunSummary = {
	passed: number,
	failed: number,
	total: number,
	results: { TestResult },
}

local function describe(value: any): string
	if typeof(value) == "string" then
		return value
	end
	return tostring(value)
end

local function waitFor(predicate: () -> boolean, timeoutSeconds: number): boolean
	local deadline = os.clock() + timeoutSeconds
	while os.clock() < deadline do
		if predicate() then
			return true
		end
		task.wait(0.1)
	end
	return predicate()
end

--=============================================================================
-- 1. Server bootstrap: remotes and the world folder exist
--=============================================================================

local function test_bootstrap_created_remotes(): (boolean, string)
	local replicated = game:GetService("ReplicatedStorage")
	local folder = replicated:FindFirstChild("BTVRemotes")
	if folder == nil then
		return false, "ReplicatedStorage.BTVRemotes was not created by Bootstrap.server."
	end
	local required = {
		"RequestEmberCommand",
		"RequestCompanionSelection",
		"StateUpdated",
		"GetInitialState",
		"MissionStateUpdated",
		"GetMissionState",
	}
	local missing = {}
	for _, name in required do
		if folder:FindFirstChild(name) == nil then
			table.insert(missing, name)
		end
	end
	if #missing > 0 then
		return false, "Missing remotes: " .. table.concat(missing, ", ")
	end
	return true, "All six remotes were created."
end

--=============================================================================
-- 2. World builders produced the expected scenes
--=============================================================================

local function test_world_scenes_exist(): (boolean, string)
	local workspaceService = game:GetService("Workspace")
	local world = workspaceService:FindFirstChild("BTV_World")
	if world == nil then
		return false, "Workspace.BTV_World was not created."
	end
	local scenes = {
		"LogosRhemaTemple_VisualPrototype",
		"Ridgeview_LandscapeStudy",
	}
	local missing = {}
	for _, name in scenes do
		if world:FindFirstChild(name) == nil then
			table.insert(missing, name)
		end
	end
	if #missing > 0 then
		return false, "Missing world scenes: " .. table.concat(missing, ", ")
	end
	return true, "Both world scenes were built."
end

local function test_temple_structure(): (boolean, string)
	local workspaceService = game:GetService("Workspace")
	local world = workspaceService:FindFirstChild("BTV_World")
	if world == nil then
		return false, "Workspace.BTV_World is missing."
	end
	local scene = world:FindFirstChild("LogosRhemaTemple_VisualPrototype")
	if scene == nil then
		return false, "Temple scene is missing."
	end
	local interior = scene:FindFirstChild("Interior")
	if interior == nil then
		return false, "Temple scene has no Interior model."
	end
	if interior:FindFirstChild("WelcomeDesk") == nil then
		return false, "WelcomeDesk is missing; the Scout Report prompt cannot attach."
	end
	if scene:FindFirstChild("PrototypeFoyerSpawn") == nil then
		return false, "PrototypeFoyerSpawn is missing."
	end
	local spawn = scene:FindFirstChild("PrototypeFoyerSpawn")
	if spawn ~= nil and spawn:IsA("SpawnLocation") and not spawn.Neutral then
		return false, "PrototypeFoyerSpawn is not neutral; team assignment could move players."
	end
	return true, "Temple interior, welcome desk and neutral spawn are present."
end

local function test_ridgeview_arrival_marker(): (boolean, string)
	local workspaceService = game:GetService("Workspace")
	local world = workspaceService:FindFirstChild("BTV_World")
	if world == nil then
		return false, "Workspace.BTV_World is missing."
	end
	local scene = world:FindFirstChild("Ridgeview_LandscapeStudy")
	if scene == nil then
		return false, "Ridgeview scene is missing."
	end
	local marker = scene:FindFirstChild("RidgeviewArrivalMarker")
	if marker == nil then
		return false, "RidgeviewArrivalMarker is missing; mission travel cannot resolve."
	end
	if not marker:IsA("BasePart") then
		return false, "RidgeviewArrivalMarker is not a BasePart."
	end
	if marker.CanCollide or marker.CanTouch or marker.CanQuery then
		return false, "RidgeviewArrivalMarker must not collide, touch or query."
	end
	return true, "RidgeviewArrivalMarker exists and is inert."
end

--=============================================================================
-- 3. Geometry: the Ridgeview cylinder-axis fix, verified in the engine
--=============================================================================
-- A Roblox Cylinder part extrudes along its LOCAL X axis. A trunk built with
-- Size = (2.1, height, 2.1) and no rotation renders as a thin vertical fin.
-- This test measures the actual part bounds in the live DataModel.

local function test_ridgeview_tree_trunks_are_upright(): (boolean, string)
	local workspaceService = game:GetService("Workspace")
	local world = workspaceService:FindFirstChild("BTV_World")
	if world == nil then
		return false, "Workspace.BTV_World is missing."
	end
	local scene = world:FindFirstChild("Ridgeview_LandscapeStudy")
	if scene == nil then
		return false, "Ridgeview scene is missing."
	end
	local woodland = scene:FindFirstChild("Woodland")
	if woodland == nil then
		return false, "Ridgeview Woodland model is missing."
	end

	-- A Roblox Cylinder part extrudes along its LOCAL X axis; the circular
	-- cross-section lies in the local Y-Z plane. A correct upright trunk is
	-- therefore authored as Size = (length, diameter, diameter) and rotated so
	-- that local X points up. A trunk authored as Size = (2.1, height, 2.1)
	-- without that rotation renders as a thin vertical fin, not a post.
	local up = Vector3.new(0, 1, 0)
	local inspected = 0
	local problems = {}
	for _, tree in woodland:GetChildren() do
		local trunk = tree:FindFirstChild("Trunk")
		if trunk ~= nil and trunk:IsA("BasePart") then
			inspected += 1
			local size = trunk.Size
			local axisIsX = size.X >= size.Y - 0.5 and size.X >= size.Z - 0.5
			local crossSectionIsRound = math.abs(size.Y - size.Z) <= math.max(0.6, 0.25 * math.max(size.Y, size.Z))
			local pointsUp = math.abs(trunk.CFrame.RightVector:Dot(up)) >= 0.9
			if not (axisIsX and crossSectionIsRound and pointsUp) then
				table.insert(
					problems,
					string.format(
						"%s (Size=%.1f,%.1f,%.1f axisX=%s round=%s up=%s)",
						tree.Name,
						size.X,
						size.Y,
						size.Z,
						tostring(axisIsX),
						tostring(crossSectionIsRound),
						tostring(pointsUp)
					)
				)
			end
		end
	end

	if inspected == 0 then
		return false, "No Ridgeview tree trunks were found to inspect."
	end
	if #problems > 0 then
		return false, string.format("%d of %d trunks are malformed: %s", #problems, inspected, table.concat(problems, " | "))
	end
	return true, string.format("All %d Ridgeview tree trunks are upright posts.", inspected)
end

--=============================================================================
-- 4. Curiosity Archive: the shared ProximityPrompt defect, observed live
--=============================================================================

local function findArchiveEntryPrompt(): ProximityPrompt?
	local workspaceService = game:GetService("Workspace")
	local world = workspaceService:FindFirstChild("BTV_World")
	if world == nil then
		return nil
	end
	local scene = world:FindFirstChild("Ridgeview_LandscapeStudy")
	if scene == nil then
		return nil
	end
	local archive = scene:FindFirstChild("CuriosityArchive")
	if archive == nil then
		return nil
	end
	local anchor = archive:FindFirstChild("ArchiveEntryPromptAnchor")
	if anchor == nil then
		return nil
	end
	local prompt = anchor:FindFirstChild("EnterArchivePrompt")
	if prompt ~= nil and prompt:IsA("ProximityPrompt") then
		return prompt
	end
	return nil
end

local function test_archive_prompt_is_shared(): (boolean, string)
	local prompt = findArchiveEntryPrompt()
	if prompt == nil then
		return false, "The Curiosity Archive entry prompt was not found."
	end
	-- The prompt text is authored as a literal "0/3". If a later change makes the
	-- server rewrite this shared instance per player, the text becomes a
	-- cross-player information leak. This test records the current behaviour.
	local text = prompt.ObjectText
	if type(text) ~= "string" or text == "" then
		return false, "The archive entry prompt has no ObjectText."
	end
	return true, "Archive entry prompt ObjectText is " .. string.format("%q", text) .. " (shared instance)."
end

--=============================================================================
-- 5. Companion actor: an Ember actor exists for a player in this place
--=============================================================================

local function test_companion_actor_spawns(): (boolean, string)
	local workspaceService = game:GetService("Workspace")
	local folder = workspaceService:FindFirstChild("BTV_Companions")
	if folder == nil then
		return false, "Workspace.BTV_Companions does not exist; no companion actor was created."
	end
	if #folder:GetChildren() == 0 then
		return false, "BTV_Companions is empty; no companion actor was created for this session."
	end
	local model = folder:GetChildren()[1]
	if not model:IsA("Model") then
		return false, "The first companion child is not a Model."
	end
	local companionId = model:GetAttribute("CompanionId")
	if companionId ~= "ember" then
		return false, "Expected an ember companion, found " .. describe(companionId)
	end
	local primary = model.PrimaryPart
	if primary == nil then
		return false, "The companion model has no PrimaryPart."
	end
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			if descendant.CanCollide then
				return false, "Companion part " .. descendant.Name .. " collides; it must not block players."
			end
			if descendant.CanTouch or descendant.CanQuery then
				return false, "Companion part " .. descendant.Name .. " must not touch or query."
			end
		end
	end
	return true, "Companion actor " .. model.Name .. " is present and inert."
end

--=============================================================================
-- 6. Mission service reachable from the live server
--=============================================================================

local function test_mission_service_state(): (boolean, string)
	local serverScriptService = game:GetService("ServerScriptService")
	local btvServer = serverScriptService:FindFirstChild("BTVServer")
	if btvServer == nil then
		return false, "ServerScriptService.BTVServer is missing."
	end
	local services = btvServer:FindFirstChild("Services")
	if services == nil then
		return false, "BTVServer.Services is missing."
	end
	local mission = services:FindFirstChild("MissionService")
	if mission == nil or not mission:IsA("ModuleScript") then
		return false, "MissionService is missing from the server tree."
	end
	local ok, snapshot = pcall(function()
		return require(mission).GetSnapshot({ UserId = 0 })
	end)
	if not ok then
		return false, "MissionService.GetSnapshot threw: " .. describe(snapshot)
	end
	if snapshot ~= nil then
		return false, "MissionService returned a snapshot for a player that never joined."
	end
	return true, "MissionService is loadable and returns no state for an unknown player."
end

--=============================================================================
-- 7. Client HUD: the touch HUD built without error (client-side check)
--=============================================================================

local function test_client_hud_present(): (boolean, string)
	if not game:GetService("RunService"):IsClient() then
		return true, "Skipped on the server; the HUD check runs on the client."
	end
	local players = game:GetService("Players")
	local localPlayer = players.LocalPlayer
	if localPlayer == nil then
		return false, "LocalPlayer is nil."
	end
	local playerGui = localPlayer:WaitForChild("PlayerGui", 10)
	if playerGui == nil then
		return false, "PlayerGui is missing."
	end
	if playerGui:FindFirstChild("BTVMobileHUD") == nil then
		return false, "BTVMobileHUD was not created on the client."
	end
	return true, "BTVMobileHUD exists on the client."
end

--=============================================================================
-- Registry
--=============================================================================

-- NOTE: StyLua 2.5.2 cannot parse positional Luau tuple types such as
-- `{ string, number }`. Use the named-field form for every table type here.
type TestFunction = () -> (boolean, string)
type TestEntry = { name: string, run: TestFunction }

local TESTS: { TestEntry } = {
	{ name = "bootstrap_remotes", run = test_bootstrap_created_remotes },
	{ name = "world_scenes_exist", run = test_world_scenes_exist },
	{ name = "temple_structure", run = test_temple_structure },
	{ name = "ridgeview_arrival_marker", run = test_ridgeview_arrival_marker },
	{ name = "ridgeview_tree_trunks_are_upright", run = test_ridgeview_tree_trunks_are_upright },
	{ name = "archive_prompt_is_shared", run = test_archive_prompt_is_shared },
	{ name = "companion_actor_spawns", run = test_companion_actor_spawns },
	{ name = "mission_service_state", run = test_mission_service_state },
	{ name = "client_hud_present", run = test_client_hud_present },
}

function EngineTests.TestNames(): { string }
	local names = {}
	for _, entry in TESTS do
		table.insert(names, entry.name)
	end
	return names
end

function EngineTests.RunOne(name: string): (boolean, string)
	for _, entry in TESTS do
		if entry.name == name then
			local ok, result = pcall(entry.run)
			if not ok then
				return false, "threw: " .. describe(result)
			end
			return result == true, describe(result)
		end
	end
	return false, "No engine test named " .. name
end

function EngineTests.RunAll(waitSeconds: number?): RunSummary
	local settle = waitSeconds or 20
	-- Give the server scripts and the world builders time to finish before the
	-- first assertion, so a slow place does not produce false failures.
	waitFor(function()
		local workspaceService = game:GetService("Workspace")
		return workspaceService:FindFirstChild("BTV_World") ~= nil
	end, settle)

	local results: { TestResult } = {}
	local passed = 0
	local failed = 0

	for _, entry in TESTS do
		local name = entry.name
		local ok, message = EngineTests.RunOne(name)
		if ok then
			passed += 1
		else
			failed += 1
		end
		table.insert(results, { name = name, ok = ok, message = message })
		print(string.format("[BTV engine test] %s %s — %s", ok and "PASS" or "FAIL", name, message))
	end

	return { passed = passed, failed = failed, total = #TESTS, results = results }
end

function EngineTests.Format(summary: RunSummary): string
	local lines = { string.format("BTV engine tests: %d passed, %d failed, %d total", summary.passed, summary.failed, summary.total) }
	for _, result in summary.results do
		table.insert(lines, string.format("%s | %s | %s", result.ok and "PASS" or "FAIL", result.name, result.message))
	end
	return table.concat(lines, "\n")
end

return table.freeze(EngineTests)
