extends SceneTree
## Unit tests for deterministic wind sampling and bounded game-prop drag.

const Wind = preload("res://scripts/wind_field.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var calm := Wind.sample_wind(Vector3.RIGHT, 0.0)
	_check(calm == Vector3.ZERO, "WIND: zero mean speed returns calm air")
	var mean := Wind.sample_wind(Vector3.RIGHT, 4.0)
	_check(mean.distance_to(Vector3(4.0, 0.0, 0.0)) < 0.0001,
		"WIND: mean direction is normalized and scaled by speed")
	var gust := Wind.sample_wind(Vector3.RIGHT, 4.0, Vector3.UP, 8.0, 1.0)
	_check(gust.distance_to(Vector3(0.0, 8.0, 0.0)) < 0.0001,
		"WIND: full gust blend selects gust vector")
	var midpoint := Wind.sample_wind(Vector3.RIGHT, 4.0, Vector3.UP, 8.0, 0.5)
	_check(midpoint.distance_to(Vector3(2.0, 4.0, 0.0)) < 0.0001,
		"WIND: gust blend is continuous and interpolated")
	var clamped := Wind.sample_wind(Vector3.RIGHT, 4.0, Vector3.UP, 8.0, 2.0)
	_check(clamped.distance_to(Vector3(0.0, 8.0, 0.0)) < 0.0001,
		"WIND: gust blend is clamped to valid range")

	var gust_a := Wind.gust_speed_offset(3.0, 0.7, 1.2, 2.0)
	var gust_b := Wind.gust_speed_offset(3.0, 0.7, 1.2, 2.0)
	_check(is_equal_approx(gust_a, gust_b), "WIND: identical time and phase reproduce gust output")
	_check(absf(gust_a) <= 2.0, "WIND: gust offset stays within configured amplitude")

	var drag_one := Wind.calculate_drag_force(Vector3.ZERO, Vector3(2.0, 0.0, 0.0), 1.0, 1.0, 1.0)
	var drag_two := Wind.calculate_drag_force(Vector3.ZERO, Vector3(4.0, 0.0, 0.0), 1.0, 1.0, 1.0)
	_check(drag_one.x > 0.0, "WIND: drag points with relative airflow")
	_check(absf(drag_two.length() / drag_one.length() - 4.0) < 0.0001,
		"WIND: doubling relative speed produces four times quadratic drag")
	var matched_velocity := Wind.calculate_drag_force(Vector3(4.0, 0.0, 0.0), Vector3(4.0, 0.0, 0.0), 1.0, 1.0, 1.0)
	_check(matched_velocity == Vector3.ZERO, "WIND: matched body and air velocity produce zero drag")
	var capped := Wind.calculate_drag_force(Vector3.ZERO, Vector3(100.0, 0.0, 0.0), 1.2, 2.0, 3.0, 1.0, 10.0)
	_check(absf(capped.length() - 10.0) < 0.0001, "WIND: force magnitude respects configured cap")
	var invalid := Wind.calculate_drag_force(Vector3.ZERO, Vector3.RIGHT, -1.0, -1.0, -1.0)
	_check(invalid == Vector3.ZERO, "WIND: negative physical inputs cannot create negative force")

	print("\nWIND_FIELD_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
