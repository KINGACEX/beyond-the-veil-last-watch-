--!strict
-- Pure lease decisions for one player's cross-server profile ownership.
-- This module does not call DataStoreService; callers must apply these decisions
-- inside an atomic UpdateAsync transformation.

local ProfileLeasePolicy = {}

export type Lease = {
	ownerToken: string,
	expiresAt: number,
}

local function isFiniteNumber(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
end

local function isValidLease(value: unknown): boolean
	return typeof(value) == "table"
		and typeof(value.ownerToken) == "string"
		and value.ownerToken ~= ""
		and isFiniteNumber(value.expiresAt)
end

local function isValidRequest(ownerToken: unknown, now: unknown, leaseDuration: unknown): boolean
	return typeof(ownerToken) == "string"
		and ownerToken ~= ""
		and isFiniteNumber(now)
		and isFiniteNumber(leaseDuration)
		and leaseDuration > 0
end

-- Returns a new lease only when the caller may own or renew the profile.
-- An unexpired lease owned by another server is never displaced.
function ProfileLeasePolicy.TryAcquire(
	existingLease: unknown,
	ownerToken: string,
	now: number,
	leaseDuration: number
): (Lease?, string?)
	if not isValidRequest(ownerToken, now, leaseDuration) then
		return nil, "Lease request is malformed."
	end

	if existingLease == nil then
		return { ownerToken = ownerToken, expiresAt = now + leaseDuration }, nil
	end

	if not isValidLease(existingLease) then
		return nil, "Existing lease is malformed; ownership cannot be established safely."
	end

	local current = existingLease :: Lease
	if current.expiresAt > now and current.ownerToken ~= ownerToken then
		return nil, "Profile is leased by another server."
	end

	return { ownerToken = ownerToken, expiresAt = now + leaseDuration }, nil
end

-- Expiry is exclusive: at expiresAt the lease is no longer valid.
function ProfileLeasePolicy.IsOwner(lease: unknown, ownerToken: string, now: number): boolean
	if not isValidLease(lease) or not isFiniteNumber(now) or typeof(ownerToken) ~= "string" or ownerToken == "" then
		return false
	end

	local current = lease :: Lease
	return current.ownerToken == ownerToken and current.expiresAt > now
end

-- Only the matching owner token may release a lease.
function ProfileLeasePolicy.TryRelease(lease: unknown, ownerToken: string): (boolean, Lease?)
	if not isValidLease(lease) or typeof(ownerToken) ~= "string" or ownerToken == "" then
		return false, nil
	end

	local current = lease :: Lease
	if current.ownerToken ~= ownerToken then
		return false, current
	end

	return true, nil
end

return table.freeze(ProfileLeasePolicy)
