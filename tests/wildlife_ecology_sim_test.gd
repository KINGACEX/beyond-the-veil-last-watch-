extends SceneTree
## Contract tests for deterministic, non-combat wildlife ecology primitives.

const Wildlife = preload("res://scripts/wildlife_ecology_sim.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var forest_species := {
		"habitat_weights": {"canopy": 0.4, "food_access": 0.3, "water_access": 0.2, "cover": 0.1}
	}
	var good_forest := {"canopy": 0.9, "food_access": 0.8, "water_access": 0.7, "cover": 0.9}
	var poor_forest := {"canopy": 0.1, "food_access": 0.2, "water_access": 0.1, "cover": 0.2}
	_check(Wildlife.habitat_suitability(forest_species, good_forest) > 0.8,
		"WILDLIFE: suitable habitat scores highly")
	_check(Wildlife.habitat_suitability(forest_species, poor_forest) < 0.2,
		"WILDLIFE: unsuitable habitat scores poorly")
	_check(Wildlife.habitat_is_viable(forest_species, good_forest),
		"WILDLIFE: viable habitat passes threshold")
	_check(not Wildlife.habitat_is_viable(forest_species, poor_forest),
		"WILDLIFE: poor habitat fails threshold")
	_check(Wildlife.habitat_suitability({}, good_forest) == 0.0,
		"WILDLIFE: missing species weights safely return zero")

	var needs := {"hunger": 0.8, "thirst": 0.3, "energy": 0.8}
	var storm := {"weather_severity": 0.95, "shelter_available": true, "water_access": 1.0, "food_access": 1.0}
	_check(Wildlife.choose_behaviour(needs, storm) == Wildlife.BEHAVIOUR_SHELTER,
		"WILDLIFE: severe weather prioritizes available shelter")
	var thirsty := {"hunger": 0.8, "thirst": 0.9, "energy": 0.8}
	var calm := {"weather_severity": 0.1, "shelter_available": true, "water_access": 1.0, "food_access": 1.0}
	_check(Wildlife.choose_behaviour(thirsty, calm) == Wildlife.BEHAVIOUR_DRINK,
		"WILDLIFE: thirst selects drinking when water is available")
	_check(Wildlife.choose_behaviour(needs, calm) == Wildlife.BEHAVIOUR_FORAGE,
		"WILDLIFE: hunger selects foraging")
	_check(Wildlife.choose_behaviour({"hunger": 0.1, "thirst": 0.1, "energy": 0.1}, calm) == Wildlife.BEHAVIOUR_REST,
		"WILDLIFE: low energy selects rest")
	_check(Wildlife.choose_behaviour({"hunger": 0.1, "thirst": 0.1, "energy": 0.8}, calm) == Wildlife.BEHAVIOUR_ROAM,
		"WILDLIFE: stable needs select ambient roaming")

	var start := {"hunger": 0.5, "thirst": 0.5, "energy": 0.5}
	var after_rest: Dictionary = Wildlife.advance_needs(start, Wildlife.BEHAVIOUR_REST, 2.0)
	_check(float(after_rest["energy"]) > float(start["energy"]),
		"WILDLIFE: rest restores energy")
	var after_forage: Dictionary = Wildlife.advance_needs(start, Wildlife.BEHAVIOUR_FORAGE, 2.0)
	_check(float(after_forage["hunger"]) < float(start["hunger"]),
		"WILDLIFE: foraging reduces hunger")
	var after_drink: Dictionary = Wildlife.advance_needs(start, Wildlife.BEHAVIOUR_DRINK, 2.0)
	_check(float(after_drink["thirst"]) < float(start["thirst"]),
		"WILDLIFE: drinking reduces thirst")
	var bounded: Dictionary = Wildlife.advance_needs({"hunger": 0.99, "thirst": 0.99, "energy": 0.01}, Wildlife.BEHAVIOUR_ROAM, 100.0)
	_check(float(bounded["hunger"]) <= 1.0 and float(bounded["thirst"]) <= 1.0 and float(bounded["energy"]) >= 0.0,
		"WILDLIFE: needs remain within normalized bounds")
	var no_time: Dictionary = Wildlife.advance_needs(start, Wildlife.BEHAVIOUR_ROAM, -5.0)
	_check(no_time == start, "WILDLIFE: negative time does not advance needs")

	var wander_a := Wildlife.deterministic_wander_direction(17, 42)
	var wander_b := Wildlife.deterministic_wander_direction(17, 42)
	var wander_c := Wildlife.deterministic_wander_direction(18, 42)
	_check(wander_a.distance_to(wander_b) < 0.000001,
		"WILDLIFE: same agent and step reproduce same wander direction")
	_check(wander_a.distance_to(wander_c) > 0.0001,
		"WILDLIFE: different agent IDs can produce varied wander directions")
	_check(is_equal_approx(wander_a.length(), 1.0),
		"WILDLIFE: wander direction is normalized")



	_check(Wildlife.simulation_tier(2.0, 5.0, 15.0, 40.0) == "near",
		"WILDLIFE: near agents use full simulation tier")
	_check(Wildlife.simulation_tier(10.0, 5.0, 15.0, 40.0) == "mid",
		"WILDLIFE: mid-distance agents use reduced simulation tier")
	_check(Wildlife.simulation_tier(25.0, 5.0, 15.0, 40.0) == "far",
		"WILDLIFE: distant agents use far population tier")
	_check(Wildlife.simulation_tier(60.0, 5.0, 15.0, 40.0) == "offscreen",
		"WILDLIFE: offscreen populations use coarse tier")
	_check(Wildlife.simulation_tier(2.0, 5.0, 4.0, 40.0) == "far",
		"WILDLIFE: invalid tier radii fail safe")

	var agent_position := Vector3.ZERO
	var neighbours: Array = [Vector3(0.5, 0.0, 0.0), Vector3(0.0, 0.0, 0.5)]
	var separation: Vector3 = Wildlife.separation_vector(12, agent_position, neighbours, 2.0, 0.8)
	_check(separation.length() > 0.0 and separation.length() <= 0.8,
		"WILDLIFE: group spacing produces a bounded separation hint")
	_check(separation.x < 0.0 and separation.z < 0.0,
		"WILDLIFE: separation points away from nearby neighbours")
	_check(Wildlife.separation_vector(12, agent_position, [Vector3(3.0, 0.0, 0.0)], 2.0, 0.8) == Vector3.ZERO,
		"WILDLIFE: adequate spacing produces no correction")
	var coincident_a: Vector3 = Wildlife.separation_vector(12, agent_position, [Vector3.ZERO], 2.0, 0.8)
	var coincident_b: Vector3 = Wildlife.separation_vector(12, agent_position, [Vector3.ZERO], 2.0, 0.8)
	_check(coincident_a.length() > 0.0 and coincident_a.distance_to(coincident_b) < 0.000001,
		"WILDLIFE: coincident agents receive deterministic separation")

	_check(Wildlife.choose_disturbance_response(20.0, 10.0, 3.0, true) == "calm",
		"WILDLIFE: distant observer causes no disturbance response")
	_check(Wildlife.choose_disturbance_response(7.0, 10.0, 3.0, true) == "pause_and_assess",
		"WILDLIFE: alert-range observer causes pause and assessment")
	_check(Wildlife.choose_disturbance_response(2.0, 10.0, 3.0, true) == "retreat_to_cover",
		"WILDLIFE: close observer causes retreat toward cover")
	_check(Wildlife.choose_disturbance_response(2.0, 10.0, 3.0, false) == "increase_distance",
		"WILDLIFE: close observer without cover causes increased distance")

	print("\nWILDLIFE_ECOLOGY_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
