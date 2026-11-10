extends SceneTree
## XH-002 — Analog composition.
##
## The touch adapter owns the analog curve exactly once. The action strength
## the player reads must equal the strength the adapter produced, with no
## second deadzone applied on top of it.

const TouchScene = preload("res://scenes/touch_controls.tscn")

const JOYSTICK_RADIUS := 70.0
const ADAPTER_DEADZONE := 0.12

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_player_input_matches_action_strength()
	await _test_deadzone_releases_the_action()
	await _test_full_deflection_is_one()
	await _test_diagonal_is_not_faster_than_full_speed()
	print("\nTOUCH_CONTROLS_COMPOSITION_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _screen_point(control: Control, local_point: Vector2) -> Vector2:
	return control.get_global_transform_with_canvas() * local_point


func _touch(index: int, pressed: bool, position: Vector2) -> InputEventScreenTouch:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.pressed = pressed
	event.position = position
	return event


func _drag(index: int, position: Vector2) -> InputEventScreenDrag:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = position
	event.relative = position
	return event


## Drags the joystick to a raw magnitude and returns the overlay.
func _drag_joystick(overlay: Control, finger: int, raw_magnitude: float, direction: Vector2 = Vector2.RIGHT) -> void:
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	var target := center + direction.normalized() * (raw_magnitude * JOYSTICK_RADIUS)
	overlay.call("_input", _touch(finger, true, center))
	overlay.call("_input", _drag(finger, target))


## The player controller composes the keyboard and touch channels once.
func _player_vector() -> Vector2:
	var keyboard := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
	var touch := Input.get_vector(&"touch_move_left", &"touch_move_right", &"touch_move_forward", &"touch_move_back")
	return (keyboard + touch).limit_length(1.0)


func _expected_strength(raw_magnitude: float) -> float:
	if raw_magnitude <= ADAPTER_DEADZONE:
		return 0.0
	return (raw_magnitude - ADAPTER_DEADZONE) / (1.0 - ADAPTER_DEADZONE)


func _test_player_input_matches_action_strength() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	for raw_magnitude: float in [0.25, 0.5, 0.75]:
		_drag_joystick(overlay, 1, raw_magnitude)
		await process_frame

		var expected := _expected_strength(raw_magnitude)
		var strength := Input.get_action_strength(&"touch_move_right")
		var vector := _player_vector()

		_check(
			is_equal_approx(strength, expected),
			"COMPOSITION: raw %.2f produces action strength %.4f (expected %.4f)" % [raw_magnitude, strength, expected],
		)
		_check(
			is_equal_approx(vector.x, strength),
			"COMPOSITION: raw %.2f player input %.4f equals the action strength (no second deadzone)" % [raw_magnitude, vector.x],
		)

		overlay.call("_input", _touch(1, false, Vector2.ZERO))
		await process_frame

	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_deadzone_releases_the_action() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	# Inside the adapter deadzone the joystick must produce no movement at all.
	_drag_joystick(overlay, 2, ADAPTER_DEADZONE * 0.5)
	await process_frame

	_check(
		is_zero_approx(Input.get_action_strength(&"touch_move_right")),
		"DEADZONE: movement inside the deadzone leaves the action at zero strength",
	)
	_check(
		is_zero_approx(_player_vector().x),
		"DEADZONE: movement inside the deadzone produces no player input",
	)

	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_full_deflection_is_one() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	_drag_joystick(overlay, 3, 1.0)
	await process_frame

	_check(
		is_equal_approx(Input.get_action_strength(&"touch_move_right"), 1.0),
		"FULL DEFLECTION: full joystick deflection reaches strength 1.0",
	)
	_check(
		is_equal_approx(_player_vector().x, 1.0),
		"FULL DEFLECTION: full joystick deflection produces full player speed",
	)

	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_diagonal_is_not_faster_than_full_speed() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	# A 45 degree drag at full radius: the adapter clamps it to the unit circle.
	_drag_joystick(overlay, 4, 1.0, Vector2(1, -1).normalized())
	await process_frame

	var vector := _player_vector()
	_check(
		vector.length() <= 1.0 + 0.001,
		"DIAGONAL: diagonal player speed %.4f does not exceed full speed" % vector.length(),
	)
	_check(
		vector.x > 0.0 and vector.y < 0.0,
		"DIAGONAL: a 45 degree drag drives both movement axes",
	)

	root.remove_child(layer)
	layer.free()
	await process_frame


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
