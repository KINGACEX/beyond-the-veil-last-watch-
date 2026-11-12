--!strict
-- Pure transformations for the versioned DataStore record.
-- Call these only from DataStore UpdateAsync callbacks; this module performs no I/O.

local ProfileRecordPolicy = {}

local function isRecord(value: unknown): boolean
	return typeof(value) == "table"
end

local function copyProfile(profile: any)
	local copy = table.clone(profile)
	copy.identity = table.clone(profile.identity)
	copy.progression = table.clone(profile.progression)
	copy.progression.completedEvaluations = table.clone(profile.progression.completedEvaluations)
	copy.progression.completedMissionIds = table.clone(profile.progression.completedMissionIds)
	copy.economy = table.clone(profile.economy)
	copy.companions = table.clone(profile.companions)
	copy.companions.owned = table.clone(profile.companions.owned)
	return copy
end

function ProfileRecordPolicy.TryAcquire(
	existingRecord: unknown,
	ownerToken: string,
	now: number,
	leaseDuration: number,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	leasePolicy: any
): (any?, string?)
	local profile
	local existingLease = nil

	if existingRecord == nil then
		profile = profileSchema.CreateDefault()
	elseif not isRecord(existingRecord) then
		return nil, "Stored profile record is malformed."
	else
		local record = existingRecord :: any
		if record.profile == nil then
			return nil, "Stored profile is missing."
		end
		local valid, validationError = profileSchema.Validate(record.profile, rankCatalog, companionCatalog)
		if not valid then
			return nil, validationError or "Stored profile failed validation."
		end
		profile = copyProfile(record.profile)
		existingLease = record.lease
	end

	local lease, leaseError = leasePolicy.TryAcquire(existingLease, ownerToken, now, leaseDuration)
	if lease == nil then
		return nil, leaseError or "Profile lease could not be acquired."
	end

	return {
		profile = profile,
		lease = lease,
	}, nil
end

function ProfileRecordPolicy.TrySave(
	existingRecord: unknown,
	ownerToken: string,
	now: number,
	leaseDuration: number,
	candidateProfile: unknown,
	profileSchema: any,
	rankCatalog: any,
	companionCatalog: any,
	leasePolicy: any
): (any?, string?)
	if not isRecord(existingRecord) then
		return nil, "Stored profile record is missing or malformed."
	end
	local record = existingRecord :: any
	if record.profile == nil then
		return nil, "Stored profile record is missing or malformed."
	end
	if not leasePolicy.IsOwner(record.lease, ownerToken, now) then
		return nil, "This server no longer owns the profile lease."
	end

	local storedProfile = record.profile
	local candidateValid, candidateError = profileSchema.Validate(candidateProfile, rankCatalog, companionCatalog)
	if not candidateValid then
		return nil, candidateError or "Candidate profile failed validation."
	end
	local storedValid = profileSchema.Validate(storedProfile, rankCatalog, companionCatalog)
	if not storedValid then
		return nil, "Stored profile failed validation; refusing to overwrite it."
	end
	local candidate = candidateProfile :: any
	if candidate.revision ~= storedProfile.revision then
		return nil, "Profile revision conflict; refusing to overwrite newer data."
	end

	local savedProfile = copyProfile(candidate)
	savedProfile.revision = storedProfile.revision + 1
	local lease, leaseError = leasePolicy.TryAcquire(record.lease, ownerToken, now, leaseDuration)
	if lease == nil then
		return nil, leaseError or "Profile lease renewal failed during save."
	end

	return {
		profile = savedProfile,
		lease = lease,
	}, nil
end

function ProfileRecordPolicy.TryRelease(
	existingRecord: unknown,
	ownerToken: string,
	leasePolicy: any
): (any?, string?)
	if not isRecord(existingRecord) then
		return nil, "Stored profile record is missing or malformed."
	end
	local record = existingRecord :: any
	if record.profile == nil then
		return nil, "Stored profile record is missing or malformed."
	end

	local released, retainedLease = leasePolicy.TryRelease(record.lease, ownerToken)
	if not released then
		return nil, "This server cannot release a lease owned by another server."
	end

	return {
		profile = record.profile,
		lease = retainedLease,
	}, nil
end

return table.freeze(ProfileRecordPolicy)
