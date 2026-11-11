extends RefCounted
class_name BTVEnvironmentQualityBudget

## Data-driven resource budget clamp.
## The caller supplies both requested values and measured device/platform caps.
## This helper deliberately contains no assumed Android device limits.


static func clamp_budget(requested: Dictionary, measured_caps: Dictionary) -> Dictionary:
	if requested.is_empty() or measured_caps.is_empty():
		return {}
	var result := {}
	for key in requested:
		if not measured_caps.has(key):
			return {}
		var requested_value: Variant = requested[key]
		var cap_value: Variant = measured_caps[key]
		if not (requested_value is int or requested_value is float):
			return {}
		if not (cap_value is int or cap_value is float):
			return {}
		if float(requested_value) < 0.0 or float(cap_value) < 0.0:
			return {}
		result[key] = minf(float(requested_value), float(cap_value))
	return result
