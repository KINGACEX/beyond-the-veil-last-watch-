--!strict
-- Server-only currency boundary. No client RemoteEvent calls this module.
-- Exact prices, award values, limits and economy rules remain UNSET.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("BTVShared")
local CurrencyAmountPolicy = require(shared:WaitForChild("CurrencyAmountPolicy"))
local PlayerStateService = require(script.Parent.PlayerStateService)

local CurrencyService = {}

-- Upper bound for a single award. Economy values are still UNSET; this only
-- stops an unbounded single award.
local MAX_AWARD_AMOUNT = 1000000

local VALID_CURRENCIES = {
	["Aces"] = true,
	["Covenant Credits"] = true,
}

-- Session-scoped idempotency; durable deduplication requires reviewed persistence.
local processedAwardContexts: { [number]: { [string]: boolean } } = {}

function CurrencyService.AwardFromServer(player: Player, currency: string, amount: number, contextKey: string): (boolean, string?)
	if not VALID_CURRENCIES[currency] then
		return false, "Currency is not recognised."
	end

	local amountVerdict = CurrencyAmountPolicy.IsValidAmount(amount, MAX_AWARD_AMOUNT)
	if not amountVerdict.ok then
		return false, amountVerdict.reason
	end

	if typeof(contextKey) ~= "string" or contextKey == "" or #contextKey > 128 then
		return false, "A valid server-side award context is required."
	end

	local userId = player.UserId
	local playerContexts = processedAwardContexts[userId]
	if playerContexts == nil then
		playerContexts = {}
		processedAwardContexts[userId] = playerContexts
	end
	if playerContexts[contextKey] then
		return false, "This award context has already been processed."
	end

	-- Call only from trusted server gameplay services after validating the mission outcome.
	local accepted, reason = PlayerStateService.AdjustCurrency(player, currency, amount)
	if accepted then
		playerContexts[contextKey] = true
	end
	return accepted, reason
end

function CurrencyService.RemovePlayer(player: Player)
	processedAwardContexts[player.UserId] = nil
end

function CurrencyService.GetBalances(player: Player): ({ aces: number, covenantCredits: number }?, string?)
	local snapshot = PlayerStateService.GetSnapshot(player)
	if snapshot == nil then
		return nil, "Session is not ready."
	end

	return {
		aces = snapshot.aces,
		covenantCredits = snapshot.covenantCredits,
	}, nil
end

return CurrencyService
