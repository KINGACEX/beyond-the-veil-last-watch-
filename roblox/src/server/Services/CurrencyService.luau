--!strict
-- Server-only currency boundary. No client RemoteEvent calls this module.
-- Exact prices, award values, limits and economy rules remain UNSET.

local PlayerStateService = require(script.Parent.PlayerStateService)

local CurrencyService = {}

local VALID_CURRENCIES = {
	["Aces"] = true,
	["Covenant Credits"] = true,
}

-- Session-level idempotency prevents duplicate server award calls from paying twice.
-- Durable idempotency must be added with the reviewed persistence/receipt schema.
local awardedContexts: {[number]: {[string]: boolean}} = {}

function CurrencyService.RemovePlayer(player: Player)
	awardedContexts[player.UserId] = nil
end

function CurrencyService.AwardFromServer(
	player: Player,
	currency: string,
	amount: number,
	contextKey: string
): (boolean, string?)
	if not VALID_CURRENCIES[currency] then
		return false, "Currency is not recognised."
	end

	if typeof(amount) ~= "number" or amount ~= amount or amount <= 0 or amount % 1 ~= 0 then
		return false, "Award amount must be a positive whole number."
	end

	if typeof(contextKey) ~= "string" or contextKey == "" or #contextKey > 128 then
		return false, "A valid server-side award context is required."
	end

	local playerContexts = awardedContexts[player.UserId]
	if playerContexts == nil then
		playerContexts = {}
		awardedContexts[player.UserId] = playerContexts
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

function CurrencyService.GetBalances(player: Player): ({aces: number, covenantCredits: number}?, string?)
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
