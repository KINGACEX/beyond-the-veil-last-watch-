extends SceneTree

const PlayerScene = preload("res://scenes/player.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_default_forward_direction()
	_test_forward_follows_camera_yaw()
	_test_diagonal_direction_is_normalized()
	_test_camera_pitch_does_not_add_vertical_movement()
	_test_zero_input_stays_zero()
	_test_mouse_look_changes_yaw_and_pitch()
	_test_mouse_look_respects_pitch_limits()
	if failures == 0:
		print("PLAYER_CAMERA_INPUT_TESTS: PASS")
		quit(0)
	else:
		printerr("PLAYER_CAMERA_INPUT_TESTS: FAIL (", failures, " failures)")
		quit(1)


func _new_player() -> CharacterBody3D:
	var instance := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(instance)
	return instance


func _test_default_forward_direction() -> void:
	var player := _new_player()
	var direction: Vector3 = player.call("_get_camera_relative_move_direction", Vector2(0, -1))
	_check(direction.is_equal_approx(Vector3(0, 0, -1)), "Forward input follows the default camera heading")
	player.queue_free()


func _test_forward_follows_camera_yaw() -> void:
	var player := _new_player()
	var pivot: Node3D = player.get_node("CameraPivot")
	var before: Vector3 = player.call("_get_camera_relative_move_direction", Vector2(0, -1))
	pivot.rotation.y = PI / 2.0
	var after: Vector3 = player.call("_get_camera_relative_move_direction", Vector2(0, -1))
	_check(before.is_equal_approx(Vector3(0, 0, -1)), "Initial forward direction is world negative Z")
	_check(after.is_equal_approx(Vector3(-1, 0, 0)), "Forward movement follows the rotated camera heading")
	player.queue_free()


func _test_diagonal_direction_is_normalized() -> void:
	var player := _new_player()
	var direction: Vector3 = player.call("_get_camera_relative_move_direction", Vector2(1, -1))
	_check(is_equal_approx(direction.length(), 1.0), "Diagonal movement is normalized to avoid a speed advantage")
	player.queue_free()


func _test_camera_pitch_does_not_add_vertical_movement() -> void:
	var player := _new_player()
	var pivot: Node3D = player.get_node("CameraPivot")
	pivot.rotation.x = deg_to_rad(-55.0)
	var direction: Vector3 = player.call("_get_camera_relative_move_direction", Vector2(0, -1))
	_check(is_zero_approx(direction.y), "Camera pitch does not tilt ground movement vertically")
	_check(is_equal_approx(direction.length(), 1.0), "Pitch-flattened movement remains normalized")
	player.queue_free()


func _test_zero_input_stays_zero() -> void:
	var player := _new_player()
	var direction: Vector3 = player.call("_get_camera_relative_move_direction", Vector2.ZERO)
	_check(direction.is_zero_approx(), "No movement input produces a zero direction")
	player.queue_free()


func _test_mouse_look_changes_yaw_and_pitch() -> void:
	var player := _new_player()
	var pivot: Node3D = player.get_node("CameraPivot")
	var initial_yaw := pivot.rotation.y
	var initial_pitch := pivot.rotation.x
	player.call("_apply_look_delta", Vector2(10, 10))
	_check(pivot.rotation.y < initial_yaw, "Mouse movement horizontally adjusts camera yaw")
	_check(pivot.rotation.x > initial_pitch, "Mouse movement vertically adjusts camera pitch")
	player.queue_free()


func _test_mouse_look_respects_pitch_limits() -> void:
	var player := _new_player()
	var pivot: Node3D = player.get_node("CameraPivot")
	player.call("_apply_look_delta", Vector2(0, -10000))
	_check(is_equal_approx(pivot.rotation.x, deg_to_rad(-70.0)), "Camera pitch is clamped at its upward limit")
	player.call("_apply_look_delta", Vector2(0, 10000))
	_check(is_equal_approx(pivot.rotation.x, deg_to_rad(35.0)), "Camera pitch is clamped at its downward limit")
	player.queue_free()


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
