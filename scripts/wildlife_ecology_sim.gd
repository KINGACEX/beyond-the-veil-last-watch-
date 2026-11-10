extends RefCounted
class_name BTVWildlifeEcologySim

## Deterministic, non-combat wildlife ecology primitives.
## This module models habitat fit and simple animal routines. It does not
## implement hunting, attacks, injury, capture, or weapon interactions.

const BEHAVIOUR_SHELTER := "shelter"
const BEHAVIOUR_DRINK := "drink"
const BEHAVIOUR_FORAGE := "forage"
const BEHAVIOUR_REST := "rest"
const BEHAVIOUR_ROAM := "roam"

## Species profiles are data, not canon approvals. Values are normalized 0..1.
static func habitat_suitability(species: Dictionary, habitat: Dictionary) -> float:
	var weights: Dictionary = species.get("habitat_weights", {})
	if weights.is_empty():
		return 0.0

	var total_weight := 0.0
	var weighted_fit := 0.0
	for key in weights:
		var weight := maxf(float(weights[key]), 0.0)
		total_weight += weight
		weighted_fit += weight * clampf(float(habitat.get(key, 0.0)), 0.0, 1.0)

	if total_weight <= 0.000001:
		return 0.0
	return clampf(weighted_fit / total_weight, 0.0, 1.0)


static func habitat_is_viable(species: Dictionary, habitat: Dictionary, minimum_fit: float = 0.45) -> bool:
	return habitat_suitability(species, habitat) >= clampf(minimum_fit, 0.0, 1.0)


## Needs use normalized values: hunger/thirst increase toward 1; energy falls toward 0.
## Priority is shelter in severe weather, then drink, forage, rest, and roam.
static func choose_behaviour(needs: Dictionary, environment: Dictionary) -> String:
	var hunger := clampf(float(needs.get("hunger", 0.0)), 0.0, 1.0)
	var thirst := clampf(float(needs.get("thirst", 0.0)), 0.0, 1.0)
	var energy := clampf(float(needs.get("energy", 1.0)), 0.0, 1.0)
	var weather_severity := clampf(float(environment.get("weather_severity", 0.0)), 0.0, 1.0)

	if weather_severity >= 0.82 and bool(environment.get("shelter_available", false)):
		return BEHAVIOUR_SHELTER
	if thirst >= 0.72 and float(environment.get("water_access", 0.0)) >= 0.2:
		return BEHAVIOUR_DRINK
	if hunger >= 0.62 and float(environment.get("food_access", 0.0)) >= 0.2:
		return BEHAVIOUR_FORAGE
	if energy <= 0.22:
		return BEHAVIOUR_REST
	return BEHAVIOUR_ROAM


## Advances needs by a bounded time step. Rates are per simulated second.
static func advance_needs(
	needs: Dictionary,
	behaviour: String,
	delta: float,
	rates: Dictionary = {}
) -> Dictionary:
	var step := clampf(delta, 0.0, 10.0)
	var result := {
		"hunger": clampf(float(needs.get("hunger", 0.0)), 0.0, 1.0),
		"thirst": clampf(float(needs.get("thirst", 0.0)), 0.0, 1.0),
		"energy": clampf(float(needs.get("energy", 1.0)), 0.0, 1.0),
	}

	var hunger_rate := maxf(float(rates.get("hunger_rate", 0.012)), 0.0)
	var thirst_rate := maxf(float(rates.get("thirst_rate", 0.016)), 0.0)
	var energy_rate := maxf(float(rates.get("energy_rate", 0.025)), 0.0)
	var recovery_rate := maxf(float(rates.get("recovery_rate", 0.06)), 0.0)

	result["hunger"] = clampf(float(result["hunger"]) + hunger_rate * step, 0.0, 1.0)
	result["thirst"] = clampf(float(result["thirst"]) + thirst_rate * step, 0.0, 1.0)

	match behaviour:
		BEHAVIOUR_DRINK:
			result["thirst"] = maxf(float(result["thirst"]) - recovery_rate * 2.0 * step, 0.0)
		BEHAVIOUR_FORAGE:
			result["hunger"] = maxf(float(result["hunger"]) - recovery_rate * 1.5 * step, 0.0)
			result["energy"] = maxf(float(result["energy"]) - energy_rate * step, 0.0)
		BEHAVIOUR_REST, BEHAVIOUR_SHELTER:
			result["energy"] = minf(float(result["energy"]) + recovery_rate * step, 1.0)
		_:
			result["energy"] = maxf(float(result["energy"]) - energy_rate * step, 0.0)

	return result


## Stable pseudo-random direction for ambient wandering, derived only from IDs.
## Callers should apply terrain/path constraints separately.
static func deterministic_wander_direction(agent_id: int, step_index: int) -> Vector3:
	var phase := float(posmod(agent_id * 92821 + step_index * 68917, 100000)) * 0.000062831853
	var vertical := sin(phase * 0.37) * 0.12
	var direction := Vector3(cos(phase), vertical, sin(phase))
	return direction.normalized()
