--!strict
-- Canonical player identity rules for the Roblox edition.
--
-- Asher Vance remains the sole Chosen and the central protagonist. Every other
-- connected player is an individual Covenant operative with their own identity
-- and session state. No player profile, session or remote may claim the
-- protagonist's identity, and no multiplayer path may quietly promote a player
-- into the Chosen role.
--
-- This module is pure so the offline Lune suite and the server can enforce the
-- same rule.

local PlayerIdentityPolicy = {}

-- The protagonist's identity. It may be used by story and NPC code only. It
-- is never assignable to a connected player.
local RESERVED_CHARACTER_ID = "asher_vance"

-- The identity a player profile carries when no reviewed per-player identity
-- has been assigned yet.
local DEFAULT_OPERATIVE_ID = "covenant_operative"

-- The Chosen role is a narrative role, not a player-selectable identity. Any
-- identity that names it is rejected rather than normalised, so a silent
-- conversion can never hide a policy breach.
local CHOSEN_MARKER = "chosen"

local MAX_IDENTITY_LENGTH = 64

export type Verdict = {
	ok: boolean,
	reason: string,
}

function PlayerIdentityPolicy.IsReservedCharacterId(value: unknown): boolean
	return typeof(value) == "string" and value == RESERVED_CHARACTER_ID
end

function PlayerIdentityPolicy.GetDefaultOperativeId(): string
	return DEFAULT_OPERATIVE_ID
end

-- A player identity is an operative identifier: lower case, underscore
-- separated, and never the protagonist's identity or a name for the Chosen role.
function PlayerIdentityPolicy.IsPlayerIdentity(value: unknown): Verdict
	if typeof(value) ~= "string" then
		return { ok = false, reason = "Player identity must be a string." }
	end
	if value == "" then
		return { ok = false, reason = "Player identity must not be empty." }
	end
	if #value > MAX_IDENTITY_LENGTH then
		return { ok = false, reason = "Player identity is too long." }
	end
	if string.find(value, CHOSEN_MARKER, 1, true) ~= nil then
		return { ok = false, reason = "A player identity must not claim the Chosen role." }
	end
	if value == RESERVED_CHARACTER_ID then
		return { ok = false, reason = "The protagonist's identity is reserved for story use." }
	end
	if string.match(value, "^[a-z][a-z0-9_]*$") == nil then
		return { ok = false, reason = "Player identity must be lower case and underscore separated." }
	end
	return { ok = true, reason = "Player identity is a valid operative identity." }
end

-- Used by the profile migration to bring a legacy profile forward. A legacy
-- identity is replaced by the default operative identity; it is never carried
-- forward as a Chosen or protagonist identity.
function PlayerIdentityPolicy.NormalizeForPlayer(value: unknown): string
	local verdict = PlayerIdentityPolicy.IsPlayerIdentity(value)
	if verdict.ok then
		return value :: string
	end
	return DEFAULT_OPERATIVE_ID
end

return table.freeze(PlayerIdentityPolicy)
