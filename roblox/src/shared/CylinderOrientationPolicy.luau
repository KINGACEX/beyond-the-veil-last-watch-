--!strict
-- Pure geometry rules for upright Roblox cylinder parts.
--
-- A Roblox Part with Shape = Enum.PartType.Cylinder extrudes along its LOCAL X
-- axis; its circular cross-section lies in the local Y-Z plane. A cylinder that
-- is meant to stand upright must therefore be authored as
-- Size = (length, diameter, diameter) and rotated so that local X points up.
--
-- A cylinder authored as Size = (diameter, length, diameter) without that
-- rotation renders as a thin vertical fin instead of a post.
--
-- This module takes plain numbers so it can be verified by the offline Lune
-- suite as well as by the engine harness inside a running place.

local CylinderOrientationPolicy = {}

local TOLERANCE = 0.5
local UPRIGHT_DOT_MINIMUM = 0.9

export type CylinderShape = {
	sizeX: number,
	sizeY: number,
	sizeZ: number,
	upDot: number,
}

export type Verdict = {
	ok: boolean,
	reason: string,
}

local function isFiniteNumber(value: number): boolean
	return typeof(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

-- upDot is the dot product between the part's local X axis (RightVector) and
-- world up. 1.0 means the cylinder already points straight up.
function CylinderOrientationPolicy.IsUpright(shape: CylinderShape): Verdict
	if not isFiniteNumber(shape.sizeX) or not isFiniteNumber(shape.sizeY) or not isFiniteNumber(shape.sizeZ) then
		return { ok = false, reason = "Cylinder size is not finite." }
	end
	if not isFiniteNumber(shape.upDot) then
		return { ok = false, reason = "Cylinder orientation is not finite." }
	end

	if shape.sizeX < shape.sizeY - TOLERANCE or shape.sizeX < shape.sizeZ - TOLERANCE then
		return {
			ok = false,
			reason = string.format("Cylinder long axis must be local X, but Size is (%.2f, %.2f, %.2f).", shape.sizeX, shape.sizeY, shape.sizeZ),
		}
	end

	local crossSectionDifference = math.abs(shape.sizeY - shape.sizeZ)
	local largestCrossSection = math.max(shape.sizeY, shape.sizeZ)
	if crossSectionDifference > math.max(0.6, 0.25 * largestCrossSection) then
		return {
			ok = false,
			reason = string.format("Cylinder cross-section must be roughly circular, but Size is (%.2f, %.2f, %.2f).", shape.sizeX, shape.sizeY, shape.sizeZ),
		}
	end

	if math.abs(shape.upDot) < UPRIGHT_DOT_MINIMUM then
		return {
			ok = false,
			reason = string.format("Cylinder long axis must point up, but its up-dot is %.2f.", shape.upDot),
		}
	end

	return { ok = true, reason = "Cylinder is an upright post." }
end

return table.freeze(CylinderOrientationPolicy)
