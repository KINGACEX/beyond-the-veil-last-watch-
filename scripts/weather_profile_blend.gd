extends RefCounted
class_name BTVWeatherProfileBlend

## Blends normalized weather-intensity profiles deterministically.
## Each profile must expose the same numeric keys, with values in 0..1.

static func blend_profiles(profiles: Array, weights: Array) -> Dictionary:
	if profiles.is_empty() or profiles.size() != weights.size():
		return {}

	var reference: Dictionary = {}
	if not profiles[0] is Dictionary:
		return {}
	reference = profiles[0]
	if reference.is_empty():
		return {}

	var total_weight := 0.0
	for index in range(profiles.size()):
		if not profiles[index] is Dictionary:
			return {}
		var profile: Dictionary = profiles[index]
		if profile.size() != reference.size():
			return {}
		for key in reference:
			if not profile.has(key):
				return {}
			var value: Variant = profile[key]
			if not (value is int or value is float):
				return {}
		var weight: Variant = weights[index]
		if not (weight is int or weight is float):
			return {}
		total_weight += maxf(float(weight), 0.0)

	if total_weight <= 0.000001:
		return {}

	var result: Dictionary = {}
	for key in reference:
		var blended_value := 0.0
		for index in range(profiles.size()):
			var profile: Dictionary = profiles[index]
			var weight := maxf(float(weights[index]), 0.0)
			blended_value += clampf(float(profile[key]), 0.0, 1.0) * weight
		result[key] = clampf(blended_value / total_weight, 0.0, 1.0)
	return result
