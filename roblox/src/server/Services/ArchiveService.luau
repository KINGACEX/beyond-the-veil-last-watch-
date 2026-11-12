--!strict
-- Server-owned, session-only discovery state for the optional Curiosity Archive.
-- Discoveries are cosmetic/exploratory only: no currency, evidence, mission or combat effects.

local ArchiveService = {}

export type ArchiveSnapshot = {
	collectedCount: number,
	requiredCount: number,
	unlocked: boolean,
	displayTitle: string,
}

local REQUIRED_MARKS = {
	"ridge_marker",
	"stream_marker",
	"lookout_marker",
}

local DISPLAY_TITLES = {
	"Companion Sketchbook",
	"Worldbuilder's Desk",
	"Field Kit Showcase",
	"Roblox Prototype Gallery",
}

local allowedMarks: { [string]: boolean } = {}
for _, markId in REQUIRED_MARKS do
	allowedMarks[markId] = true
end

type PlayerIdentity = { UserId: number }
type PlayerArchiveState = { collected: { [string]: boolean } }
local states: { [number]: PlayerArchiveState } = {}

local function getDisplayTitle(unixTime: number?): string
	local currentTime = unixTime or os.time()
	local weekIndex = math.floor(currentTime / 604800) % #DISPLAY_TITLES + 1
	return DISPLAY_TITLES[weekIndex]
end

function ArchiveService.AddPlayer(player: PlayerIdentity)
	states[player.UserId] = { collected = {} }
end

function ArchiveService.RemovePlayer(player: PlayerIdentity)
	states[player.UserId] = nil
end

function ArchiveService.GetSnapshot(player: PlayerIdentity, unixTime: number?): ArchiveSnapshot?
	local state = states[player.UserId]
	if state == nil then
		return nil
	end

	local count = 0
	for _, markId in REQUIRED_MARKS do
		if state.collected[markId] == true then
			count += 1
		end
	end

	return {
		collectedCount = count,
		requiredCount = #REQUIRED_MARKS,
		unlocked = count == #REQUIRED_MARKS,
		displayTitle = getDisplayTitle(unixTime),
	}
end

function ArchiveService.Collect(player: PlayerIdentity, markId: unknown): (boolean, ArchiveSnapshot?)
	local state = states[player.UserId]
	if state == nil or typeof(markId) ~= "string" or allowedMarks[markId] ~= true then
		return false, nil
	end
	if state.collected[markId] == true then
		return false, ArchiveService.GetSnapshot(player)
	end

	state.collected[markId] = true
	return true, ArchiveService.GetSnapshot(player)
end

function ArchiveService.GetDisplayTitle(unixTime: number?): string
	return getDisplayTitle(unixTime)
end

return ArchiveService
