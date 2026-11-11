--!strict
-- Server-only currency boundary. No client RemoteEvent calls this module.
-- Exact prices, award values, limits and economy rules remain UNSET.

local PlayerStateService = require(script.Parent.PlayerStateService)

local CurrencyService = {}

local VALID_CURRENCIES = {
	["Aces"] = true,
	["Covenant Credits"] = true,
}

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

	if typeof(contextKey) ~= "string" or contextKey == "" then
		return false, "A server-side award context is required."
	end

	-- Call only from trusted server gameplay services after validating the mission outcome.
	return PlayerStateService.AdjustCurrency(player, currency, amount)
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
