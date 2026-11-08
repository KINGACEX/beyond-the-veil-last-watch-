extends SceneTree
## XH-002 — Touch and keyboard coexistence.
##
## Touch cleanup must never cancel an action that another input source is
## holding.

const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_touch_release_keeps_a_keyboard_held_action()
	await _test_focus_loss_keeps_a_keyboard_held_action()
	await _test_teardown_keeps_a_keyboard_held_action()
	print("\nTOUCH_CONTROLS_COEXISTENCE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
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


func _drag_joystick(overlay: Control, finger: int) -> void:
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	overlay.call("_input", _touch(finger, true, center))
	overlay.call("_input", _drag(finger, center + Vector2(100, 0)))


func _test_touch_release_keeps_a_keyboard_held_action() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	# A key is held down on move_forward while the joystick is used.
	Input.action_press(&"move_forward")
	await process_frame
	_check(Input.is_action_pressed(&"move_forward"), "COEXISTENCE: move_forward is held before the touch")

	_drag_joystick(overlay, 1)
	await process_frame
	_check(Input.get_action_strength(&"move_right") > 0.0, "COEXISTENCE: the joystick drives move_right")

	# Releasing the joystick must not cancel the separately held action.
	overlay.call("_input", _touch(1, false, Vector2.ZERO))
	await process_frame
	_check(
		Input.is_action_pressed(&"move_forward"),
		"COEXISTENCE: releasing the joystick does not cancel the held move_forward",
	)

	Input.action_release(&"move_forward")
	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_focus_loss_keeps_a_keyboard_held_action() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	Input.action_press(&"interact")
	await process_frame
	_check(Input.is_action_pressed(&"interact"), "COEXISTENCE: interact is held before focus loss")

	overlay.call("_notification", NOTIFICATION_APPLICATION_FOCUS_OUT)
	await process_frame
	_check(
		Input.is_action_pressed(&"interact"),
		"COEXISTENCE: focus loss does not cancel the held interact action",
	)

	Input.action_release(&"interact")
	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_teardown_keeps_a_keyboard_held_action() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame

	Input.action_press(&"move_back")
	await process_frame
	_drag_joystick(overlay, 2)
	await process_frame

	root.remove_child(layer)
	layer.free()
	await process_frame

	_check(
		Input.is_action_pressed(&"move_back"),
		"COEXISTENCE: touch scene teardown does not cancel the held move_back action",
	)
	_check(
		is_zero_approx(Input.get_action_strength(&"move_right")),
		"COEXISTENCE: touch scene teardown still releases the action the touch owned",
	)

	Input.action_release(&"move_back")
	await process_frame


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
