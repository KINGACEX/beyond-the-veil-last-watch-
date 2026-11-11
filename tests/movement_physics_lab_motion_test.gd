extends SceneTree
## Measures the initial grounded movement response in the neutral lab.
## Values are provisional tuning candidates; this test protects their response envelope.

const LabScene = preload("res://scenes/movement_physics_lab.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_clear_movement_actions()
	root.size = Vector2i(1280, 720)
	await process_frame
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	var player := lab.get_node("Player") as BTVPlayerController
	for _tick in range(3):
		await physics_frame

	var speed_limit := player.move_speed
	Input.action_press(&"move_forward")
	for _tick in range(2):
		await physics_frame
	var early_speed := _horizontal_speed(player)
	_check(
		early_speed > 0.0 and early_speed < speed_limit,
		"MOTION: acceleration is progressive rather than an instant jump to target speed",
	)

	for _tick in range(30):
		await physics_frame
	var cruise_speed := _horizontal_speed(player)
	_check(
		is_equal_approx(cruise_speed, speed_limit),
		"MOTION: held input reaches the configured maximum speed",
	)

	Input.action_release(&"move_forward")
	for _tick in range(2):
		await physics_frame
	var braking_speed := _horizontal_speed(player)
	_check(
		braking_speed > 0.0 and braking_speed < cruise_speed,
		"MOTION: releasing input produces a measurable braking phase",
	)

	for _tick in range(30):
		await physics_frame
	_check(
		_is_zero_speed(_horizontal_speed(player)),
		"MOTION: braking returns horizontal velocity to zero without drift",
	)

	Input.action_press(&"move_forward")
	Input.action_press(&"move_right")
	for _tick in range(30):
		await physics_frame
	var diagonal_speed := _horizontal_speed(player)
	_check(
		is_equal_approx(diagonal_speed, speed_limit),
		"MOTION: diagonal movement does not exceed the configured speed cap",
	)

	_clear_movement_actions()
	await _reset_player(player, Vector3.ZERO)
	Input.action_press(&"move_right")
	for _tick in range(2):
		await physics_frame
	var early_yaw := absf(player.rotation.y)
	_check(
		early_yaw > 0.0 and early_yaw < PI * 0.5,
		"MOTION: character rotation begins progressively rather than snapping instantly",
	)
	for _tick in range(30):
		await physics_frame
	var final_yaw := absf(player.rotation.y)
	_check(
		absf(final_yaw - PI * 0.5) < 0.05,
		"MOTION: character rotation converges on the movement direction",
	)
	_clear_movement_actions()

	await _reset_player(player, Vector3.ZERO)
	Input.action_press(&"move_forward")
	for _tick in range(30):
		await physics_frame
	var release_position := player.global_position
	Input.action_release(&"move_forward")
	for _tick in range(30):
		await physics_frame
	var stop_distance := absf(player.global_position.z - release_position.z)
	_check(
		stop_distance >= 0.25 and stop_distance <= 0.42,
		"MOTION: braking stop distance remains inside the initial 0.25–0.42 m test envelope",
	)

	# Direction reversal must remain progressive and bounded rather than snapping.
	await _reset_player(player, Vector3.ZERO)
	Input.action_press(&"move_forward")
	for _tick in range(30):
		await physics_frame
	var forward_speed := _horizontal_speed(player)
	Input.action_release(&"move_forward")
	Input.action_press(&"move_back")
	for _tick in range(2):
		await physics_frame
	var reversal_speed := _horizontal_speed(player)
	_check(
		reversal_speed < forward_speed and reversal_speed > 0.0,
		"MOTION: reversing direction reduces existing momentum progressively",
	)
	for _tick in range(30):
		await physics_frame
	var reverse_speed := _horizontal_speed(player)
	_check(
		is_equal_approx(reverse_speed, speed_limit),
		"MOTION: sustained reverse input reaches the same speed cap",
	)

	# A diagonal release should brake both horizontal axes without residual drift.
	await _reset_player(player, Vector3.ZERO)
	Input.action_press(&"move_forward")
	Input.action_press(&"move_right")
	for _tick in range(30):
		await physics_frame
	var diagonal_release_position := player.global_position
	Input.action_release(&"move_forward")
	Input.action_release(&"move_right")
	for _tick in range(30):
		await physics_frame
	var diagonal_stop_distance := Vector2(
		player.global_position.x - diagonal_release_position.x,
		player.global_position.z - diagonal_release_position.z,
	).length()
	_check(
		_is_zero_speed(_horizontal_speed(player)),
		"MOTION: diagonal braking returns both horizontal velocity components to zero",
	)
	_check(
		diagonal_stop_distance > 0.0 and diagonal_stop_distance < 0.5,
		"MOTION: diagonal braking remains within a bounded stop-distance envelope",
	)

	_clear_movement_actions()
	root.remove_child(lab)
	lab.free()
	await process_frame
	print("\nMOVEMENT_PHYSICS_LAB_MOTION_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _reset_player(player: BTVPlayerController, spawn: Vector3) -> void:
	_clear_movement_actions()
	player.velocity = Vector3.ZERO
	player.global_position = spawn
	player.rotation = Vector3.ZERO
	for _tick in range(3):
		await physics_frame


func _horizontal_speed(player: CharacterBody3D) -> float:
	return Vector2(player.velocity.x, player.velocity.z).length()


func _is_zero_speed(speed: float) -> bool:
	return speed <= 0.001


func _clear_movement_actions() -> void:
	for action_name in [&"move_forward", &"move_back", &"move_left", &"move_right"]:
		Input.action_release(action_name)
	for action_name in [&"touch_move_forward", &"touch_move_back", &"touch_move_left", &"touch_move_right"]:
		Input.action_release(action_name)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
