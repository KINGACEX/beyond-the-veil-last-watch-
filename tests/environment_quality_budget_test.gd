extends SceneTree
## Tests data-driven graphics/environment budgets without inventing device caps.

const QualityBudget = preload("res://scripts/environment_quality_budget.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var requested := {
		"shadow_casters": 12,
		"wildlife_near_updates": 10,
		"particle_instances": 240,
	}
	var measured_caps := {
		"shadow_casters": 4,
		"wildlife_near_updates": 6,
		"particle_instances": 180,
	}
	var resolved: Dictionary = QualityBudget.clamp_budget(requested, measured_caps)
	_check(resolved.get("shadow_casters", -1.0) == 4.0,
		"QUALITY_BUDGET: shadow caster request clamps to measured cap")
	_check(resolved.get("wildlife_near_updates", -1.0) == 6.0,
		"QUALITY_BUDGET: wildlife update request clamps independently")
	_check(resolved.get("particle_instances", -1.0) == 180.0,
		"QUALITY_BUDGET: particle request clamps independently")

	var under_cap: Dictionary = QualityBudget.clamp_budget(
		{"shadow_casters": 2}, {"shadow_casters": 4}
	)
	_check(under_cap.get("shadow_casters", -1.0) == 2.0,
		"QUALITY_BUDGET: lower requests remain unchanged")
	_check(QualityBudget.clamp_budget(
		{"shadow_casters": 2, "unknown": 1}, {"shadow_casters": 4}
	).is_empty(), "QUALITY_BUDGET: missing measured cap rejects the profile")
	_check(QualityBudget.clamp_budget(
		{"shadow_casters": -1}, {"shadow_casters": 4}
	).is_empty(), "QUALITY_BUDGET: negative requested value is rejected")
	_check(QualityBudget.clamp_budget(
		{"shadow_casters": 2}, {"shadow_casters": -1}
	).is_empty(), "QUALITY_BUDGET: negative measured cap is rejected")
	_check(QualityBudget.clamp_budget(
		{"shadow_casters": "many"}, {"shadow_casters": 4}
	).is_empty(), "QUALITY_BUDGET: non-numeric request is rejected")
	_check(QualityBudget.clamp_budget(
		{"shadow_casters": 2}, {"shadow_casters": "four"}
	).is_empty(), "QUALITY_BUDGET: non-numeric cap is rejected")
	_check(QualityBudget.clamp_budget({}, {"shadow_casters": 4}).is_empty(),
		"QUALITY_BUDGET: empty request is rejected")
	_check(QualityBudget.clamp_budget({"shadow_casters": 2}, {}).is_empty(),
		"QUALITY_BUDGET: missing measurement set is rejected")

	print("\nENVIRONMENT_QUALITY_BUDGET_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
