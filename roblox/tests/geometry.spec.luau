--!strict
-- Offline regression checks for the world geometry the runtime harness verifies.
-- Run from the roblox directory with: lune run tests/geometry.spec.luau
--
-- The live engine test (tests/engine/EngineTests.luau) can only run inside a
-- Roblox Studio place. These checks cover the same rule offline so a broken
-- build is caught before a Studio licence is needed, and so the correction
-- itself is provable from the repository.

local fs = require("@lune/fs")

local CylinderOrientationPolicy = require("../src/shared/CylinderOrientationPolicy")

local function expect(condition: boolean, message: string)
	if not condition then
		error("[BTV geometry test failed] " .. message)
	end
end

-- Lune has no `io` global; the filesystem API lives in @lune/fs.
local function readFile(path: string): string?
	if not fs.isFile(path) then
		return nil
	end
	local contents = fs.readFile(path)
	if type(contents) ~= "string" then
		return nil
	end
	return contents
end

local function expectContains(haystack: string, needle: string, message: string)
	expect(string.find(haystack, needle, 1, true) ~= nil, message .. " (missing: " .. needle .. ")")
end

local function expectNotContains(haystack: string, needle: string, message: string)
	expect(string.find(haystack, needle, 1, true) == nil, message .. " (unexpectedly present: " .. needle .. ")")
end

-- 1. The rule rejects the Ridgeview authoring that shipped in the audit.
--    Size = (2.1, height, 2.1) puts the long axis on local Y, so the part
--    renders as a thin vertical fin instead of a post.
local broken = CylinderOrientationPolicy.IsUpright({ sizeX = 2.1, sizeY = 9.5, sizeZ = 2.1, upDot = 1 })
expect(not broken.ok, "a cylinder with its long axis on local Y must be rejected")

-- 2. The rule rejects a correctly sized cylinder that was never rotated,
--    because its long axis (local X) is still lying flat.
local notRotated = CylinderOrientationPolicy.IsUpright({ sizeX = 9.5, sizeY = 2.1, sizeZ = 2.1, upDot = 0 })
expect(not notRotated.ok, "a cylinder whose long axis points sideways must be rejected")

-- 3. The rule rejects a non-round cross-section.
local flattened = CylinderOrientationPolicy.IsUpright({ sizeX = 9.5, sizeY = 2.1, sizeZ = 4.0, upDot = 1 })
expect(not flattened.ok, "a cylinder with a flattened cross-section must be rejected")

-- 4. The rule rejects non-finite input instead of silently passing it.
local notFinite = CylinderOrientationPolicy.IsUpright({ sizeX = 0 / 0, sizeY = 2.1, sizeZ = 2.1, upDot = 1 })
expect(not notFinite.ok, "a cylinder with a non-finite size must be rejected")

-- 4b. The exact values the engine harness measured on the pre-fix Ridgeview
--     trunks: a cylinder with Size (2.1, height, 2.1) and no rotation, so its
--     local X (the long axis) points along world X. The harness rejects these.
local measuredBeforeFix = CylinderOrientationPolicy.IsUpright({ sizeX = 2.1, sizeY = 9.5, sizeZ = 2.1, upDot = 0 })
expect(not measuredBeforeFix.ok, "the pre-fix Ridgeview trunk measurements must be rejected")

-- 5. The rule accepts the corrected authoring: long axis on local X, round
--    cross-section, local X rotated to point up.
local corrected = CylinderOrientationPolicy.IsUpright({ sizeX = 9.5, sizeY = 2.1, sizeZ = 2.1, upDot = 1 })
expect(corrected.ok, "the corrected upright cylinder authoring must be accepted: " .. corrected.reason)

-- 6. The Ridgeview study must no longer author the broken cylinder.
local ridgeviewSource = readFile("src/server/World/RidgeviewLandscapeStudy.server.luau")
expect(ridgeviewSource ~= nil, "RidgeviewLandscapeStudy.server.luau is missing")
expectNotContains(ridgeviewSource :: string, "Vector3.new(2.1, height, 2.1)", "Ridgeview tree trunks must not keep the broken cylinder size")
expectContains(ridgeviewSource :: string, "Vector3.new(height, 2.1, 2.1)", "Ridgeview tree trunks must be authored with the long axis on local X")
expectContains(ridgeviewSource :: string, "CFrame.Angles(0, 0, math.rad(90))", "Ridgeview tree trunks must be rotated so local X points up")

-- 7. The temple's already-correct column pattern must survive the correction.
local templeSource = readFile("src/server/World/LogoRhemaTemple.server.luau")
if templeSource ~= nil then
	expectContains(templeSource :: string, "CFrame.Angles(0, 0, math.rad(90))", "the temple columns must keep their upright rotation")
end

-- 8. The departure sign must face the player, who approaches from positive Z.
local missionSource = readFile("src/server/World/OpeningMission.server.luau")
expect(missionSource ~= nil, "OpeningMission.server.luau is missing")
expectContains(missionSource :: string, "CFrame.Angles(0, math.pi, 0)", "the Ridgeview departure sign must be turned to face the approaching player")

print("[BTV geometry test] passed")
return true
