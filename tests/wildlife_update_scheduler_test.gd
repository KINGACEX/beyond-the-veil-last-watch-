extends SceneTree
## Tests bounded and fair wildlife update scheduling without spawning agents.

const Wildlife = preload("res://scripts/wildlife_ecology_sim.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var distances := [2.0, 3.0, 4.0, 8.0, 12.0, 22.0, 30.0, 60.0]
	var budgets := {"near": 2, "mid": 1, "far": 1, "offscreen": 1}
	var first: Dictionary = Wildlife.schedule_updates(distances, 5.0, 15.0, 40.0, budgets, 0)
	_check(not first.is_empty(), "WILDLIFE_SCHEDULER: valid inputs produce a schedule")
	_check(first.get("tier_for_agent", []).size() == distances.size(),
		"WILDLIFE_SCHEDULER: every agent receives a distance tier")
	_check(first.get("selected_indices", []).size() == 5,
		"WILDLIFE_SCHEDULER: total selected work respects the sum of tier budgets")
	_check(first.get("tier_counts", {}).get("near", -1) == 2,
		"WILDLIFE_SCHEDULER: near tier respects its independent budget")
	_check(first.get("tier_counts", {}).get("mid", -1) == 1,
		"WILDLIFE_SCHEDULER: mid tier respects its independent budget")
	_check(first.get("tier_for_agent", []) == [
		"near", "near", "near", "mid", "mid", "far", "far", "offscreen"
	], "WILDLIFE_SCHEDULER: distance tiers remain in input order")

	var selected_frame_0: Array = Wildlife.schedule_updates(
		[1.0, 2.0, 3.0], 5.0, 10.0, 20.0, {"near": 1}, 0
	).get("selected_indices", [])
	var selected_frame_1: Array = Wildlife.schedule_updates(
		[1.0, 2.0, 3.0], 5.0, 10.0, 20.0, {"near": 1}, 1
	).get("selected_indices", [])
	var selected_frame_2: Array = Wildlife.schedule_updates(
		[1.0, 2.0, 3.0], 5.0, 10.0, 20.0, {"near": 1}, 2
	).get("selected_indices", [])
	_check(selected_frame_0 == [0] and selected_frame_1 == [1] and selected_frame_2 == [2],
		"WILDLIFE_SCHEDULER: rotating start gives over-budget agents fair turns")

	var zero_budget: Dictionary = Wildlife.schedule_updates(
		[1.0, 8.0], 5.0, 10.0, 20.0, {}, 0
	)
	_check(zero_budget.get("selected_indices", [1]).is_empty(),
		"WILDLIFE_SCHEDULER: omitted tier budgets default to zero")
	_check(Wildlife.schedule_updates(distances, 5.0, 4.0, 40.0, budgets, 0).is_empty(),
		"WILDLIFE_SCHEDULER: invalid distance radii are rejected")
	_check(Wildlife.schedule_updates([1.0, "bad"], 5.0, 10.0, 20.0, budgets, 0).is_empty(),
		"WILDLIFE_SCHEDULER: non-numeric distance is rejected")
	_check(Wildlife.schedule_updates([1.0], 5.0, 10.0, 20.0, {"near": -1}, 0).is_empty(),
		"WILDLIFE_SCHEDULER: negative update budget is rejected")

	print("\nWILDLIFE_UPDATE_SCHEDULER_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
