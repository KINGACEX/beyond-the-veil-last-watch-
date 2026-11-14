--!strict
-- Pure, side-effect-free player profile schema and migration rules.
-- This module deliberately does not access DataStoreService or enable persistence.

local PlayerProfileSchema = {}

local CURRENT_SCHEMA_VERSION = 7
local LEGACY_SCHEMA_VERSION = 1
local INVENTORY_SCHEMA_VERSION = 2
local TRANSACTION_SCHEMA_VERSION = 3
local INVESTIGATION_SCHEMA_VERSION = 4
local CONSENT_DECISION_SCHEMA_VERSION = 5
local ACTIVE_MISSION_SCHEMA_VERSION = 6
local MISSION_REGION_SCHEMA_VERSION = 7
local MAX_RECENT_TRANSACTIONS = 50
local DEFAULT_OWNERSHIP: {[string]: boolean} = table.freeze({
	ember = true,
	fox = true,
	owl = true,
	horse = true,
})

local function isNonEmptyString(value: unknown): boolean
	return typeof(value) == "string" and value ~= ""
end

local function isNonNegativeInteger(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
		and value >= 0
		and value % 1 == 0
end

local function validateStringArray(value: unknown): boolean
	if typeof(value) ~= "table" then
		return false
	end

	local count = 0
	local seen: {[string]: boolean} = {}
	for key, item in value do
		if typeof(key) ~= "number" or key < 1 or key % 1 ~= 0 or not isNonEmptyString(item) then
			return false
		end
		if seen[item] then
			return false
		end
		seen[item] = true
		count += 1
	end

	return count == #value
end

local function copyProfile(profile: any)
	local copy = table.clone(profile)
	copy.identity = table.clone(profile.identity)
	copy.progression = table.clone(profile.progression)
	copy.progression.completedEvaluations = table.clone(profile.progression.completedEvaluations)
	copy.progression.completedMissionIds = table.clone(profile.progression.completedMissionIds)
	if profile.progression.activeMission ~= nil then
		copy.progression.activeMission = table.clone(profile.progression.activeMission)
	end
	copy.economy = table.clone(profile.economy)
	if profile.economy.recentTransactions ~= nil then
		copy.economy.recentTransactions = table.clone(profile.economy.recentTransactions)
		for index, transaction in copy.economy.recentTransactions do
			copy.economy.recentTransactions[index] = table.clone(transaction)
		end
	end
	copy.companions = table.clone(profile.companions)
	copy.companions.owned = table.clone(profile.companions.owned)
	if profile.inventory ~= nil then
		copy.inventory = table.clone(profile.inventory)
		copy.inventory.items = table.clone(profile.inventory.items)
	end
	if profile.investigation ~= nil then
		copy.investigation = table.clone(profile.investigation)
		copy.investigation.ridgeview = table.clone(profile.investigation.ridgeview)
		copy.investigation.ridgeview.observations = table.clone(profile.investigation.ridgeview.observations)
	end
	return copy
end

local function validateProfile(
	profile: unknown,
	expectedVersion: number,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any?,
	itemCatalog: any?
): (boolean, string?)
	if typeof(profile) ~= "table" then
		return false, "Profile must be a table."
	end
	if profile.schemaVersion ~= expectedVersion then
		return false, "Unsupported profile schema version."
	end
	if not isNonNegativeInteger(profile.revision) then
		return false, "Profile revision must be a non-negative integer."
	end

	local identity = profile.identity
	if typeof(identity) ~= "table"
		or not isNonEmptyString(identity.characterId)
		or not isNonEmptyString(identity.covenantBranch)
	then
		return false, "Profile identity is malformed."
	end

	local progression = profile.progression
	if typeof(progression) ~= "table" then
		return false, "Profile progression is malformed."
	end
	if rankCatalog.GetRankIndex(progression.covenantRank) == nil then
		return false, "Profile contains an unknown Covenant rank."
	end
	if not validateStringArray(progression.completedEvaluations)
		or not validateStringArray(progression.completedMissionIds)
	then
		return false, "Profile progression event lists are malformed."
	end

	if expectedVersion >= ACTIVE_MISSION_SCHEMA_VERSION then
		local activeMission = progression.activeMission
		if typeof(activeMission) ~= "table" then
			return false, "Active mission progress is malformed."
		end
		local phaseIndices = {
			communion_context = 1,
			covenant_alert = 2,
			report_accessed = 3,
			ridgeview_arrival = 4,
			ridgeview_investigation = 5,
			mission_complete = 6,
		}
		if phaseIndices[activeMission.phase] == nil
			or activeMission.sequenceIndex ~= phaseIndices[activeMission.phase]
		then
			return false, "Active mission phase and sequence are inconsistent."
		end
		if activeMission.phase == "ridgeview_investigation" then
			local validObjectives = {
				collect_observations = true,
				speak_with_wren = true,
				choose_disclosure = true,
				pike_followup = true,
				review_findings = true,
			}
			if typeof(activeMission.ridgeviewObjective) ~= "string" or validObjectives[activeMission.ridgeviewObjective] ~= true then
				return false, "Active Ridgeview objective is invalid."
			end
		elseif activeMission.ridgeviewObjective ~= nil then
			return false, "A non-investigation phase cannot contain a Ridgeview objective."
		end
		local isCompleted = table.find(progression.completedMissionIds, "ridgeview_investigation_001") ~= nil
		if (activeMission.phase == "mission_complete") ~= isCompleted then
			return false, "Completed mission history and active mission state disagree."
		end
		if expectedVersion >= MISSION_REGION_SCHEMA_VERSION then
			if activeMission.region ~= "temple" and activeMission.region ~= "ridgeview" then
				return false, "Active mission region is invalid."
			end
			local phaseAllowsRidgeview = activeMission.phase == "ridgeview_arrival"
				or activeMission.phase == "ridgeview_investigation"
				or activeMission.phase == "mission_complete"
			if activeMission.region == "ridgeview" and not phaseAllowsRidgeview then
				return false, "Ridgeview region requires a Ridgeview mission phase."
			end
		end
	end

	local economy = profile.economy
	if typeof(economy) ~= "table"
		or not isNonNegativeInteger(economy.aces)
		or not isNonNegativeInteger(economy.covenantCredits)
	then
		return false, "Profile currency balances are malformed."
	end

	local companions = profile.companions
	if typeof(companions) ~= "table" or typeof(companions.owned) ~= "table" then
		return false, "Profile companion ownership is malformed."
	end

	local definitionsById: {[string]: any} = {}
	for _, definition in companionCatalog do
		definitionsById[definition.Id] = definition
	end

	for companionId, isOwned in companions.owned do
		local definition = definitionsById[companionId]
		if definition == nil or typeof(isOwned) ~= "boolean" then
			return false, "Profile contains an invalid companion ownership entry."
		end
		if isOwned and definition.Access == "PremiumCandidate" then
			return false, "Profile cannot grant an unconfigured premium companion."
		end
	end

	local equippedDefinition = definitionsById[companions.equipped]
	if equippedDefinition == nil or companions.owned[companions.equipped] ~= true then
		return false, "Equipped companion must be present in the ownership map."
	end
	if equippedDefinition.Access == "PremiumCandidate" then
		return false, "An unconfigured premium companion cannot be equipped."
	end

	if expectedVersion >= INVENTORY_SCHEMA_VERSION then
		if inventoryPolicy == nil or itemCatalog == nil then
			return false, "Inventory validation dependencies are missing."
		end
		local inventoryValid, inventoryError = inventoryPolicy.Validate(profile.inventory, itemCatalog)
		if not inventoryValid then
			return false, inventoryError or "Profile inventory is malformed."
		end
	end

	if expectedVersion >= TRANSACTION_SCHEMA_VERSION then
		local recentTransactions = economy.recentTransactions
		if typeof(recentTransactions) ~= "table" or #recentTransactions > MAX_RECENT_TRANSACTIONS then
			return false, "Recent transaction journal is malformed or exceeds its limit."
		end
		local seenTransactionIds: {[string]: boolean} = {}
		for index, transaction in recentTransactions do
			if typeof(index) ~= "number" or index < 1 or index % 1 ~= 0 or typeof(transaction) ~= "table" then
				return false, "Recent transaction journal contains a malformed entry."
			end
			if not isNonEmptyString(transaction.id) or #transaction.id > 128 or seenTransactionIds[transaction.id] then
				return false, "Recent transaction journal contains an invalid or duplicate ID."
			end
			if (transaction.kind ~= "MerchantPurchase" and transaction.kind ~= "MerchantSale")
				or not isNonEmptyString(transaction.itemId)
				or not isNonNegativeInteger(transaction.quantity)
				or transaction.quantity == 0
				or not isNonNegativeInteger(transaction.unitPrice)
				or transaction.unitPrice == 0
				or typeof(transaction.acesDelta) ~= "number"
				or transaction.acesDelta ~= transaction.acesDelta
				or transaction.acesDelta == math.huge
				or transaction.acesDelta == -math.huge
				or transaction.acesDelta % 1 ~= 0
			then
				return false, "Recent transaction journal contains invalid transaction data."
			end
			seenTransactionIds[transaction.id] = true
		end
	end

	if expectedVersion >= INVESTIGATION_SCHEMA_VERSION then
		local investigation = profile.investigation
		local ridgeview = if typeof(investigation) == "table" then investigation.ridgeview else nil
		if typeof(ridgeview) ~= "table"
			or typeof(ridgeview.observations) ~= "table"
			or typeof(ridgeview.wrenTestimonyRecorded) ~= "boolean"
			or typeof(ridgeview.wrenSharePermission) ~= "boolean"
			or (expectedVersion >= CONSENT_DECISION_SCHEMA_VERSION and typeof(ridgeview.wrenDisclosureDecisionMade) ~= "boolean")
			or typeof(ridgeview.pikeAdmissionRecorded) ~= "boolean"
		then
			return false, "Ridgeview investigation profile is malformed."
		end
		for noteId, recorded in ridgeview.observations do
			if (noteId ~= "approach_belongings" and noteId ~= "parked_work_vehicle") or recorded ~= true then
				return false, "Ridgeview profile contains an unknown or invalid observation."
			end
		end
		if expectedVersion >= CONSENT_DECISION_SCHEMA_VERSION and ridgeview.wrenSharePermission and not ridgeview.wrenDisclosureDecisionMade then
			return false, "Ridgeview sharing permission has no recorded disclosure decision."
		end
		if ridgeview.wrenSharePermission and not ridgeview.wrenTestimonyRecorded then
			return false, "Ridgeview sharing permission cannot exist without recorded testimony."
		end
		if ridgeview.pikeAdmissionRecorded and not ridgeview.wrenSharePermission then
			return false, "Pike's admission cannot exist without Wren's explicit sharing permission."
		end
	end

	return true, nil
end

local function createDefaultInvestigation()
	return {
		ridgeview = {
			observations = {},
			wrenTestimonyRecorded = false,
			wrenSharePermission = false,
			wrenDisclosureDecisionMade = false,
			pikeAdmissionRecorded = false,
		},
	}
end

function PlayerProfileSchema.CreateDefault()
	return {
		schemaVersion = CURRENT_SCHEMA_VERSION,
		revision = 0,
		identity = {
			characterId = "covenant_operative",
			covenantBranch = "Unassigned",
		},
		progression = {
			covenantRank = "Recruit",
			completedEvaluations = {},
			completedMissionIds = {},
			activeMission = {
				phase = "communion_context",
				sequenceIndex = 1,
				ridgeviewObjective = nil,
				region = "temple",
			},
		},
		economy = {
			aces = 0,
			covenantCredits = 0,
			recentTransactions = {},
		},
		companions = {
			owned = table.clone(DEFAULT_OWNERSHIP),
			equipped = "ember",
		},
		inventory = {
			items = {},
		},
		investigation = createDefaultInvestigation(),
	}
end

function PlayerProfileSchema.Validate(
	profile: unknown,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any
): (boolean, string?)
	return validateProfile(profile, CURRENT_SCHEMA_VERSION, rankCatalog, companionCatalog, inventoryPolicy, itemCatalog)
end

function PlayerProfileSchema.Migrate(
	profile: unknown,
	rankCatalog: any,
	companionCatalog: any,
	inventoryPolicy: any,
	itemCatalog: any
): (any?, string?)
	if typeof(profile) ~= "table" then
		return nil, "Profile must be a table."
	end

	if profile.schemaVersion == LEGACY_SCHEMA_VERSION
		or profile.schemaVersion == INVENTORY_SCHEMA_VERSION
		or profile.schemaVersion == TRANSACTION_SCHEMA_VERSION
		or profile.schemaVersion == INVESTIGATION_SCHEMA_VERSION
		or profile.schemaVersion == CONSENT_DECISION_SCHEMA_VERSION
		or profile.schemaVersion == ACTIVE_MISSION_SCHEMA_VERSION
	then
		local sourceVersion = profile.schemaVersion
		local sourceValid, sourceError = validateProfile(
			profile,
			sourceVersion,
			rankCatalog,
			companionCatalog,
			if sourceVersion >= INVENTORY_SCHEMA_VERSION then inventoryPolicy else nil,
			if sourceVersion >= INVENTORY_SCHEMA_VERSION then itemCatalog else nil
		)
		if not sourceValid then
			return nil, sourceError or "Legacy profile failed validation."
		end

		local migrated = copyProfile(profile)
		if sourceVersion == LEGACY_SCHEMA_VERSION then
			migrated.inventory = inventoryPolicy.CreateDefault()
		end
		if sourceVersion < TRANSACTION_SCHEMA_VERSION then
			migrated.economy.recentTransactions = {}
		end
		if sourceVersion < INVESTIGATION_SCHEMA_VERSION then
			migrated.investigation = createDefaultInvestigation()
		elseif sourceVersion < CONSENT_DECISION_SCHEMA_VERSION then
			local ridgeview = migrated.investigation.ridgeview
			-- Older saves cannot prove that a false permission was explicitly chosen.
			-- Keep the account private and require Wren's decision to be reconfirmed.
			ridgeview.wrenDisclosureDecisionMade = ridgeview.wrenSharePermission == true
		end
		if sourceVersion < ACTIVE_MISSION_SCHEMA_VERSION then
			local completed = table.find(migrated.progression.completedMissionIds, "ridgeview_investigation_001") ~= nil
			migrated.progression.activeMission = {
				phase = if completed then "mission_complete" else "communion_context",
				sequenceIndex = if completed then 6 else 1,
				ridgeviewObjective = nil,
			}
		end
		if sourceVersion < MISSION_REGION_SCHEMA_VERSION then
			local phase = migrated.progression.activeMission.phase
			migrated.progression.activeMission.region = if phase == "ridgeview_arrival" or phase == "ridgeview_investigation" or phase == "mission_complete"
				then "ridgeview"
				else "temple"
		end
		migrated.schemaVersion = CURRENT_SCHEMA_VERSION
		local migratedValid, migratedError = validateProfile(
			migrated,
			CURRENT_SCHEMA_VERSION,
			rankCatalog,
			companionCatalog,
			inventoryPolicy,
			itemCatalog
		)
		if not migratedValid then
			return nil, migratedError or "Migrated profile failed validation."
		end
		return migrated, nil
	end

	if profile.schemaVersion == CURRENT_SCHEMA_VERSION then
		local valid, validationError = validateProfile(
			profile,
			CURRENT_SCHEMA_VERSION,
			rankCatalog,
			companionCatalog,
			inventoryPolicy,
			itemCatalog
		)
		if not valid then
			return nil, validationError or "Profile failed validation."
		end
		return copyProfile(profile), nil
	end

	return nil, "Unsupported profile schema version."
end

return table.freeze(PlayerProfileSchema)
