extends SceneTree
## XH-003 — Same-action input composition.
##
## Touch owns its own action namespace, so a touch release can never clear a
## keyboard hold and a keyboard press can never mask the joystick's analog
## strength. These tests pin that separation in both release orders, for
## movement and for the discrete Interact action, and pin the focus-loss and
## touch-cancellation paths that must not reach across the namespace.
##
## A real InputEventKey is used for the keyboard so the test exercises the
## same path a physical key takes, not a synthetic Input.action_press() call.

const TouchScene = preload("res://scenes/touch_controls.tscn")
const PlayerScene = preload("res://scenes/player.tscn")

var failures := 0
var _player: CharacterBody3D


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	_player = PlayerScene.instantiate() as CharacterBody3D
	root.add_child(_player)
	await process_frame
	await _test_keyboard_release_leaves_touch_running()
	await _test_touch_release_leaves_keyboard_running()
	await _test_both_released_stops_movement()
	await _test_keyboard_and_touch_same_direction_are_capped()
	await _test_interact_sources_are_independent()
	await _test_focus_loss_does_not_cancel_the_keyboard()
	await _test_touch_cancellation_does_not_cancel_the_keyboard()
	root.remove_child(_player)
	_player.free()
	await process_frame
	print("\nXH003_SAME_ACTION_COMPOSITION_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
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


func _key(pressed: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = KEY_W
	event.keycode = KEY_W
	event.pressed = pressed
	Input.parse_input_event(event)
	await process_frame


func _key_e(pressed: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = KEY_E
	event.keycode = KEY_E
	event.pressed = pressed
	Input.parse_input_event(event)
	await process_frame


## Drags the joystick "forward" (negative Y on screen drives touch_move_forward).
func _drag_joystick_forward(overlay: Control, finger: int) -> void:
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	overlay.call("_input", _touch(finger, true, center))
	overlay.call("_input", _drag(finger, center + Vector2(0, -100)))


func _release_joystick(overlay: Control, finger: int) -> void:
	overlay.call("_input", _touch(finger, false, Vector2.ZERO))


func _clear_actions() -> void:
	for action_name: StringName in [
		&"move_forward", &"move_back", &"move_left", &"move_right", &"interact",
		&"touch_move_forward", &"touch_move_back", &"touch_move_left",
		&"touch_move_right", &"touch_interact",
	]:
		Input.action_release(action_name)


func _make_overlay() -> Control:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	var overlay: Control = layer.get_node("Overlay")
	# The shipped overlay is hidden without a touchscreen; this suite exercises
	# touch behaviour, so it must run with the overlay visible.
	overlay.visible = true
	return overlay


func _teardown(overlay: Control) -> void:
	var layer := overlay.get_parent()
	root.remove_child(layer)
	layer.free()
	await process_frame
	_clear_actions()


## Reads the real composition from the player controller rather than repeating
## it here, so the test pins the shipped code path.
func _composed() -> Vector2:
	return _player.call("_compose_movement_intent")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)


## Order A: the keyboard is released first; the touch contribution must continue.
func _test_keyboard_release_leaves_touch_running() -> void:
	print("\n[Order A] keyboard released first, touch keeps moving")
	var overlay := _make_overlay()
	await process_frame

	_drag_joystick_forward(overlay, 1)
	await process_frame
	_check(
		Input.get_action_strength(&"touch_move_forward") > 0.0,
		"A1: the joystick drives the touch_move_forward action",
	)

	await _key(true)
	await process_frame
	_check(
		Input.is_action_pressed(&"move_forward"),
		"A2: the physical W key holds the keyboard move_forward action",
	)
	_check(
		Input.get_action_strength(&"touch_move_forward") > 0.0,
		"A2: the keyboard press does not mask the joystick's analog strength",
	)

	await _key(false)
	await process_frame
	_check(
		Input.get_action_strength(&"touch_move_forward") > 0.0,
		"A3: releasing the keyboard does not clear the touch contribution",
	)
	_check(
		_composed().y < 0.0,
		"A3: the composed movement intent still points forward",
	)

	await _teardown(overlay)


## Order B: the touch is released first; the keyboard contribution must continue.
func _test_touch_release_leaves_keyboard_running() -> void:
	print("\n[Order B] touch released first, keyboard keeps moving")
	var overlay := _make_overlay()
	await process_frame

	await _key(true)
	await process_frame
	_drag_joystick_forward(overlay, 1)
	await process_frame
	_check(
		Input.is_action_pressed(&"move_forward")
		and Input.get_action_strength(&"touch_move_forward") > 0.0,
		"B1: both sources hold their own action at the same time",
	)

	_release_joystick(overlay, 1)
	await process_frame
	_check(
		Input.get_action_strength(&"touch_move_forward") == 0.0,
		"B2: releasing the joystick clears the touch action",
	)
	_check(
		Input.is_action_pressed(&"move_forward"),
		"B2: releasing the joystick does not cancel the keyboard-held action",
	)
	_check(
		_composed().y < 0.0,
		"B2: the composed movement intent still points forward from the keyboard",
	)

	await _teardown(overlay)


## Both sources released means no movement at all.
func _test_both_released_stops_movement() -> void:
	print("\n[Both released] no source remains")
	var overlay := _make_overlay()
	await process_frame

	await _key(true)
	_drag_joystick_forward(overlay, 1)
	await process_frame
	await _key(false)
	_release_joystick(overlay, 1)
	await process_frame

	_check(
		not Input.is_action_pressed(&"move_forward")
		and Input.get_action_strength(&"touch_move_forward") == 0.0,
		"BOTH: releasing every source leaves no action held",
	)
	_check(
		_composed().is_zero_approx(),
		"BOTH: the composed movement intent returns to zero",
	)

	await _teardown(overlay)


## Two sources on the same axis must not exceed the movement speed cap.
func _test_keyboard_and_touch_same_direction_are_capped() -> void:
	print("\n[Cap] two sources on one axis")
	var overlay := _make_overlay()
	await process_frame

	await _key(true)
	_drag_joystick_forward(overlay, 1)
	await process_frame
	var composed := _composed()
	_check(
		composed.length() <= 1.001,
		"CAP: the composed intent never exceeds unit length",
	)

	await _teardown(overlay)


## Interact is a discrete action: each source owns it, and neither can cancel the other.
func _test_interact_sources_are_independent() -> void:
	print("\n[Interact] independent sources")
	var overlay := _make_overlay()
	await process_frame

	await _key_e(true)
	await process_frame
	_check(
		Input.is_action_pressed(&"interact"),
		"INTERACT: the physical E key holds the keyboard interact action",
	)

	# The touch Interact button drives its own action.
	overlay.call("_press_action", &"touch_interact")
	await process_frame
	_check(
		Input.is_action_pressed(&"touch_interact"),
		"INTERACT: the touch button holds the touch_interact action",
	)

	overlay.call("_release_action", &"touch_interact")
	await process_frame
	_check(
		not Input.is_action_pressed(&"touch_interact"),
		"INTERACT: releasing the touch button clears the touch action",
	)
	_check(
		Input.is_action_pressed(&"interact"),
		"INTERACT: releasing the touch button does not cancel the keyboard-held interact",
	)

	await _key_e(false)
	await process_frame
	_check(
		not Input.is_action_pressed(&"interact"),
		"INTERACT: releasing the keyboard clears the keyboard action",
	)

	await _teardown(overlay)


## Focus loss clears touch input and nothing else.
func _test_focus_loss_does_not_cancel_the_keyboard() -> void:
	print("\n[Focus loss] cleanup stays inside the touch namespace")
	var overlay := _make_overlay()
	await process_frame

	await _key(true)
	_drag_joystick_forward(overlay, 1)
	await process_frame

	overlay.call("_cancel_all_touch_input")
	await process_frame
	_check(
		Input.get_action_strength(&"touch_move_forward") == 0.0,
		"FOCUS: touch cancellation clears the touch action",
	)
	_check(
		Input.is_action_pressed(&"move_forward"),
		"FOCUS: touch cancellation does not cancel the keyboard-held action",
	)

	await _teardown(overlay)


## Touch teardown clears touch input and nothing else.
func _test_touch_cancellation_does_not_cancel_the_keyboard() -> void:
	print("\n[Teardown] the overlay leaving the tree stays inside the touch namespace")
	var overlay := _make_overlay()
	await process_frame

	await _key(true)
	_drag_joystick_forward(overlay, 1)
	await process_frame

	var layer := overlay.get_parent()
	root.remove_child(layer)
	layer.free()
	await process_frame
	_check(
		Input.get_action_strength(&"touch_move_forward") == 0.0,
		"TEARDOWN: teardown clears the touch action",
	)
	_check(
		Input.is_action_pressed(&"move_forward"),
		"TEARDOWN: teardown does not cancel the keyboard-held action",
	)

	_clear_actions()
	await process_frame
