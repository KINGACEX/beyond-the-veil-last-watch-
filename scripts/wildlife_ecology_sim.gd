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
		var raw_weight: Variant = weights[key]
		var raw_habitat: Variant = habitat.get(key, 0.0)
		if not (raw_weight is int or raw_weight is float) or not is_finite(float(raw_weight)):
			return 0.0
		if not (raw_habitat is int or raw_habitat is float) or not is_finite(float(raw_habitat)):
			return 0.0
		var weight := maxf(float(raw_weight), 0.0)
		total_weight += weight
		weighted_fit += weight * clampf(float(raw_habitat), 0.0, 1.0)

	if total_weight <= 0.000001:
		return 0.0
	return clampf(weighted_fit / total_weight, 0.0, 1.0)


static func habitat_is_viable(species: Dictionary, habitat: Dictionary, minimum_fit: float = 0.45) -> bool:
	if not is_finite(minimum_fit):
		return false
	return habitat_suitability(species, habitat) >= clampf(minimum_fit, 0.0, 1.0)


## Needs use normalized values: hunger/thirst increase toward 1; energy falls toward 0.
## Priority is shelter in severe weather, then drink, forage, rest, and roam.
static func choose_behaviour(needs: Dictionary, environment: Dictionary) -> String:
	var hunger := _normalized_value(needs, "hunger", 0.0)
	var thirst := _normalized_value(needs, "thirst", 0.0)
	var energy := _normalized_value(needs, "energy", 1.0)
	var weather_severity := _normalized_value(environment, "weather_severity", 0.0)

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
	var step := clampf(delta, 0.0, 10.0) if is_finite(delta) else 0.0
	var result := {
		"hunger": _normalized_value(needs, "hunger", 0.0),
		"thirst": _normalized_value(needs, "thirst", 0.0),
		"energy": _normalized_value(needs, "energy", 1.0),
	}

	var hunger_rate := _nonnegative_rate(rates, "hunger_rate", 0.012)
	var thirst_rate := _nonnegative_rate(rates, "thirst_rate", 0.016)
	var energy_rate := _nonnegative_rate(rates, "energy_rate", 0.025)
	var recovery_rate := _nonnegative_rate(rates, "recovery_rate", 0.06)

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


## Distance-based simulation tiers for mobile population budgets.
## Radii must be positive and strictly increasing; invalid settings fail safe to far.
static func simulation_tier(distance: float, near_radius: float, mid_radius: float, far_radius: float) -> String:
	if not (is_finite(distance) and is_finite(near_radius) and is_finite(mid_radius) and is_finite(far_radius)):
		return "far"
	if near_radius <= 0.0 or mid_radius <= near_radius or far_radius <= mid_radius:
		return "far"
	var safe_distance := maxf(distance, 0.0)
	if safe_distance <= near_radius:
		return "near"
	if safe_distance <= mid_radius:
		return "mid"
	if safe_distance <= far_radius:
		return "far"
	return "offscreen"


## Returns a bounded separation vector. It is a steering hint only; callers
## must still use collision/navigation constraints and cap agent speed.
static func separation_vector(
	agent_id: int,
	agent_position: Vector3,
	neighbour_positions: Array,
	minimum_distance: float,
	maximum_strength: float
) -> Vector3:
	var safe_distance := maxf(minimum_distance, 0.001)
	var safe_strength := maxf(maximum_strength, 0.0)
	if safe_strength <= 0.0:
		return Vector3.ZERO

	var accumulated := Vector3.ZERO
	for index in range(neighbour_positions.size()):
		var neighbour: Variant = neighbour_positions[index]
		if not neighbour is Vector3:
			continue
		var offset: Vector3 = agent_position - neighbour
		var distance := offset.length()
		if distance >= safe_distance:
			continue
		if distance <= 0.0001:
			# Stable tie-break for coincident positions; avoids NaN/zero division.
			var fallback := deterministic_wander_direction(agent_id, index + 1)
			accumulated += Vector3(fallback.x, 0.0, fallback.z).normalized()
		else:
			accumulated += offset / distance * ((safe_distance - distance) / safe_distance)

	if accumulated.length_squared() <= 0.000001:
		return Vector3.ZERO
	return accumulated.normalized() * minf(accumulated.length(), safe_strength)


## Ambient disturbance responses are nonviolent and do not target or attack
## the observer. Distances are world units; caller owns visibility/audio sensing.
static func choose_disturbance_response(
	distance: float,
	alert_radius: float,
	retreat_radius: float,
	cover_available: bool
) -> String:
	var safe_distance := maxf(distance, 0.0)
	var safe_alert := maxf(alert_radius, 0.0)
	var safe_retreat := clampf(retreat_radius, 0.0, safe_alert)
	if safe_distance > safe_alert:
		return "calm"
	if safe_distance <= safe_retreat:
		return "retreat_to_cover" if cover_available else "increase_distance"
	return "pause_and_assess"


static func _normalized_value(source: Dictionary, key: String, fallback: float) -> float:
	var raw: Variant = source.get(key, fallback)
	if not (raw is int or raw is float) or not is_finite(float(raw)):
		return fallback
	return clampf(float(raw), 0.0, 1.0)


static func _nonnegative_rate(rates: Dictionary, key: String, fallback: float) -> float:
	var raw: Variant = rates.get(key, fallback)
	if not (raw is int or raw is float) or not is_finite(float(raw)):
		return fallback
	return maxf(float(raw), 0.0)


## Schedules bounded wildlife updates across distance tiers.
## The caller supplies per-tier update budgets and advances frame_index each frame.
## Rotating start positions prevent the same agents being starved when a tier is over budget.
static func schedule_updates(
	distances: Array,
	near_radius: float,
	mid_radius: float,
	far_radius: float,
	update_budgets: Dictionary,
	frame_index: int
) -> Dictionary:
	if near_radius <= 0.0 or mid_radius <= near_radius or far_radius <= mid_radius:
		return {}

	var tier_for_agent: Array[String] = []
	var agents_by_tier := {
		"near": [],
		"mid": [],
		"far": [],
		"offscreen": [],
	}
	for agent_index in range(distances.size()):
		var distance_value: Variant = distances[agent_index]
		if not (distance_value is int or distance_value is float):
			return {}
		var tier := simulation_tier(float(distance_value), near_radius, mid_radius, far_radius)
		tier_for_agent.append(tier)
		var tier_agents: Array = agents_by_tier[tier]
		tier_agents.append(agent_index)
		agents_by_tier[tier] = tier_agents

	var selected_indices: Array[int] = []
	var tier_counts := {}
	for tier in ["near", "mid", "far", "offscreen"]:
		var requested: Variant = update_budgets.get(tier, 0)
		if not (requested is int or requested is float) or float(requested) < 0.0:
			return {}
		var candidates: Array = agents_by_tier[tier]
		var slots := mini(int(floor(float(requested))), candidates.size())
		tier_counts[tier] = slots
		if slots <= 0 or candidates.is_empty():
			continue
		var start_index := posmod(frame_index, candidates.size())
		for offset in range(slots):
			selected_indices.append(int(candidates[(start_index + offset) % candidates.size()]))

	return {
		"tier_for_agent": tier_for_agent,
		"selected_indices": selected_indices,
		"tier_counts": tier_counts,
	}
