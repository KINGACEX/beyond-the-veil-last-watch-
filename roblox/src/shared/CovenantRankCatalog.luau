--!strict
-- Approved Roblox Covenant rank order. This is progression data only;
-- promotion criteria and authority permissions are implemented separately.
local RANKS: {string} = {
	"Recruit",
	"Field Agent",
	"Senior Agent",
	"Elite Agent",
	"Specialist",
	"Senior Specialist",
	"Principal Specialist",
	"Team Leader",
	"Senior Team Leader",
	"Unit Leader",
	"Field Commander",
	"Senior Commander",
	"Regional Commander",
	"Senior General",
	"High General",
}

local rankIndices: {[string]: number} = {}
for index, rank in RANKS do
	rankIndices[rank] = index
end

local CovenantRankCatalog = {}

function CovenantRankCatalog.GetRankIndex(rank: string): number?
	return rankIndices[rank]
end

function CovenantRankCatalog.GetNextRank(rank: string): string?
	local index = rankIndices[rank]
	if index == nil then
		return nil
	end
	return RANKS[index + 1]
end

function CovenantRankCatalog.IsAtLeast(rank: string, requiredRank: string): boolean
	local rankIndex = rankIndices[rank]
	local requiredIndex = rankIndices[requiredRank]
	return rankIndex ~= nil and requiredIndex ~= nil and rankIndex >= requiredIndex
end

CovenantRankCatalog.Ranks = table.freeze(RANKS)
return table.freeze(CovenantRankCatalog)
