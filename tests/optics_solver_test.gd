extends SceneTree
## Unit checks for deterministic reflection, refraction and critical-angle handling.

const Solver = preload("res://scripts/optics_solver.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var reflected := Solver.reflect_direction(Vector3(1.0, -1.0, 0.0), Vector3.UP)
	_check(reflected.distance_to(Vector3(1.0, 1.0, 0.0).normalized()) < 0.0001,
		"OPTICS: reflection obeys equal-angle vector law")
	_check(Solver.reflect_direction(Vector3.ZERO, Vector3.UP) == Vector3.ZERO,
		"OPTICS: zero-length input is handled safely")

	var incoming := Vector3(0.5, -sqrt(0.75), 0.0)
	var refracted: Dictionary = Solver.refract_direction(incoming, Vector3.UP, 1.0, 1.5)
	_check(bool(refracted.valid), "OPTICS: air-to-glass refraction is valid")
	_check(not bool(refracted.total_internal_reflection), "OPTICS: air-to-glass does not trigger TIR")
	var output_direction: Vector3 = refracted.direction
	var measured_sine := absf(output_direction.x)
	_check(absf(measured_sine - (1.0 / 3.0)) < 0.0001,
		"OPTICS: Snell law gives sin(theta2)=1/3 for 30-degree air-to-glass")

	var critical := Solver.critical_angle_radians(1.5, 1.0)
	_check(absf(rad_to_deg(critical) - 41.8103) < 0.01,
		"OPTICS: glass-to-air critical angle is approximately 41.81 degrees")
	var high_angle := Vector3(sin(deg_to_rad(50.0)), -cos(deg_to_rad(50.0)), 0.0)
	var tir: Dictionary = Solver.refract_direction(high_angle, Vector3.UP, 1.5, 1.0)
	_check(bool(tir.valid) and bool(tir.total_internal_reflection),
		"OPTICS: 50-degree glass-to-air incidence triggers TIR")
	var normal_incidence: Dictionary = Solver.refract_direction(Vector3.DOWN, Vector3.UP, 1.0, 1.5)
	var normal_direction: Vector3 = normal_incidence.direction
	_check(normal_direction.distance_to(Vector3.DOWN) < 0.0001,
		"OPTICS: normal incidence does not change ray direction")
	var invalid_index: Dictionary = Solver.refract_direction(Vector3.DOWN, Vector3.UP, 0.0, 1.5)
	_check(not bool(invalid_index.valid), "OPTICS: non-positive refractive index is rejected")

	print("\nOPTICS_SOLVER_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
