extends SceneTree
## Traversal-only dash regression checks: bounded travel and collision-safe cancellation.

const LabScene = preload("res://scenes/movement_physics_lab.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_clear_dash()
	root.size = Vector2i(1280, 720)
	await process_frame
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	var player := lab.get_node("Player") as BTVPlayerController
	for _tick in range(4):
		await physics_frame
	_check(player.is_on_floor(), "DASH: player begins grounded")

	var start_position := player.global_position
	Input.action_press(&"dash")
	await physics_frame
	Input.action_release(&"dash")
	for _tick in range(8):
		await physics_frame
	var dash_displacement := start_position.distance_to(player.global_position)
	_check(
		dash_displacement > 0.65,
		"DASH: a fresh input produces measurable traversal displacement",
	)
	_check(
		float(player.get("_dash_time_remaining")) > 0.0,
		"DASH: configured burst remains active during its authored duration",
	)
	for _tick in range(20):
		await physics_frame
	_check(
		is_zero_approx(player.velocity.x) and is_zero_approx(player.velocity.z),
		"DASH: horizontal velocity is cleared after the burst ends",
	)

	await _reset_player(player, Vector3(0.0, 0.0, -10.0))
	Input.action_press(&"dash")
	await physics_frame
	Input.action_release(&"dash")
	for _tick in range(12):
		await physics_frame
	_check(
		player.global_position.z > -10.65,
		"DASH: collision prevents traversal through the front wall",
	)
	_check(
		float(player.get("_dash_time_remaining")) <= 0.0,
		"DASH: wall contact cancels the remaining burst",
	)

	_clear_dash()
	root.remove_child(lab)
	lab.free()
	await process_frame
	print("\\nTRAVERSAL_DASH_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _reset_player(player: BTVPlayerController, spawn: Vector3) -> void:
	_clear_dash()
	player.velocity = Vector3.ZERO
	player.global_position = spawn
	player.rotation = Vector3.ZERO
	for _tick in range(4):
		await physics_frame


func _clear_dash() -> void:
	Input.action_release(&"dash")
	Input.action_release(&"touch_dash")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
