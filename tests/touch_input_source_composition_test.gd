extends SceneTree
## XH-003 — End-to-end input-source composition contract.
##
## Exercises the same composition method used by the player controller and
## verifies that either source can be released without cancelling the other.

const PlayerScene = preload("res://scenes/player.tscn")

var player: BTVPlayerController
var failures := 0

const ACTIONS: Array[StringName] = [
	&"move_forward", &"move_back", &"move_left", &"move_right", &"interact",
	&"touch_move_forward", &"touch_move_back", &"touch_move_left",
	&"touch_move_right", &"touch_interact",
]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	player = PlayerScene.instantiate() as BTVPlayerController
	root.add_child(player)
	await process_frame

	await _test_keyboard_only()
	await _test_touch_only()
	await _test_same_direction_is_capped()
	await _test_different_directions_are_composed()
	await _test_keyboard_release_first()
	await _test_touch_release_first()
	await _test_interact_sources()

	_reset_actions()
	root.remove_child(player)
	player.free()
	print("\nTOUCH_INPUT_SOURCE_COMPOSITION_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _test_keyboard_only() -> void:
	_reset_actions()
	Input.action_press(&"move_right")
	_check_vector(player._get_composed_movement_input(), Vector2.RIGHT, "KEYBOARD ONLY: keyboard movement is unchanged")
	_reset_actions()
	await process_frame


func _test_touch_only() -> void:
	_reset_actions()
	Input.action_press(&"touch_move_forward")
	_check_vector(player._get_composed_movement_input(), Vector2.UP, "TOUCH ONLY: touch movement reaches the player")
	_reset_actions()
	await process_frame


func _test_same_direction_is_capped() -> void:
	_reset_actions()
	Input.action_press(&"move_right")
	Input.action_press(&"touch_move_right")
	_check_vector(player._get_composed_movement_input(), Vector2.RIGHT, "SAME DIRECTION: keyboard and touch sum without exceeding unit speed")
	_reset_actions()
	await process_frame


func _test_different_directions_are_composed() -> void:
	_reset_actions()
	Input.action_press(&"move_right")
	Input.action_press(&"touch_move_forward")
	_check_vector(
		player._get_composed_movement_input(),
		Vector2(1.0, -1.0).normalized(),
		"DIFFERENT DIRECTIONS: independent axes compose and clamp to unit magnitude",
	)
	_reset_actions()
	await process_frame


func _test_keyboard_release_first() -> void:
	_reset_actions()
	Input.action_press(&"move_right")
	Input.action_press(&"touch_move_right")
	Input.action_release(&"move_right")
	_check_vector(player._get_composed_movement_input(), Vector2.RIGHT, "RELEASE ORDER A: touch continues after keyboard release")
	Input.action_release(&"touch_move_right")
	_check_vector(player._get_composed_movement_input(), Vector2.ZERO, "RELEASE ORDER A: both sources released means no movement")
	await process_frame


func _test_touch_release_first() -> void:
	_reset_actions()
	Input.action_press(&"move_left")
	Input.action_press(&"touch_move_left")
	Input.action_release(&"touch_move_left")
	_check_vector(player._get_composed_movement_input(), Vector2.LEFT, "RELEASE ORDER B: keyboard continues after touch release")
	Input.action_release(&"move_left")
	_check_vector(player._get_composed_movement_input(), Vector2.ZERO, "RELEASE ORDER B: both sources released means no movement")
	await process_frame


func _test_interact_sources() -> void:
	_reset_actions()
	Input.action_press(&"interact")
	_check(player._is_interact_just_pressed(), "INTERACT: keyboard press is accepted")
	_check(not player._is_interact_just_pressed(), "INTERACT: a held keyboard press does not repeat")
	Input.action_press(&"touch_interact")
	_check(not player._is_interact_just_pressed(), "INTERACT: touch joining a held keyboard press does not create a second edge")
	Input.action_release(&"interact")
	_check(not player._is_interact_just_pressed(), "INTERACT: touch keeps the combined control latched after keyboard release")
	Input.action_release(&"touch_interact")
	await process_frame

	Input.action_press(&"touch_interact")
	_check(player._is_interact_just_pressed(), "INTERACT: touch press is accepted after the combined control is released")
	Input.action_release(&"touch_interact")
	await process_frame

	Input.action_press(&"interact")
	Input.action_press(&"touch_interact")
	_check(player._is_interact_just_pressed(), "INTERACT: simultaneous source presses produce one interaction edge")
	_check(not player._is_interact_just_pressed(), "INTERACT: simultaneous held sources do not repeat")
	_reset_actions()
	await process_frame


func _reset_actions() -> void:
	for action_name: StringName in ACTIONS:
		Input.action_release(action_name)


func _check_vector(actual: Vector2, expected: Vector2, label: String) -> void:
	_check(actual.distance_to(expected) <= 0.001, "%s (actual=%s expected=%s)" % [label, actual, expected])


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
