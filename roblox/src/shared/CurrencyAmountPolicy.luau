--!strict
-- Pure rules for currency amounts.
--
-- Economy values, award sizes and price points are still UNSET, so this module
-- does not decide what an award is worth. It only decides what a well-formed
-- amount looks like, so that both the currency boundary and the session state
-- service can reject malformed numbers without trusting each other.
--
-- Pure numbers only, so the offline Lune suite can verify it.

local CurrencyAmountPolicy = {}

export type Verdict = {
	ok: boolean,
	reason: string,
}

function CurrencyAmountPolicy.IsValidAmount(amount: number, limit: number): Verdict
	if typeof(amount) ~= "number" then
		return { ok = false, reason = "Award amount must be a number." }
	end
	if amount ~= amount then
		return { ok = false, reason = "Award amount must be a number." }
	end
	if amount == math.huge or amount == -math.huge then
		return { ok = false, reason = "Award amount must be a finite number." }
	end
	if amount % 1 ~= 0 then
		return { ok = false, reason = "Award amount must be a positive whole number." }
	end
	if amount <= 0 then
		return { ok = false, reason = "Award amount must be a positive whole number." }
	end
	if limit > 0 and amount > limit then
		return {
			ok = false,
			reason = string.format("Award amount must not exceed the limit of %d.", limit),
		}
	end
	return { ok = true, reason = "Award amount is valid." }
end

return table.freeze(CurrencyAmountPolicy)
