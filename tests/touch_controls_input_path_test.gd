extends SceneTree
## XH-002 — Real input path.
##
## The existing integration suite calls the overlay's `_input` handler
## directly. These tests push events through the viewport instead, so the
## real delivery order (Node._input -> GUI -> Node._unhandled_input) and the
## set_input_as_handled() behaviour are exercised.

const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_joystick_responds_to_viewport_input()
	await _test_interact_button_fires_through_the_viewport()
	await _test_hidden_overlay_does_not_drive_the_player()
	print("\nTOUCH_CONTROLS_INPUT_PATH_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
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


func _test_joystick_responds_to_viewport_input() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	var joystick: Control = overlay.get_node("JoystickBase")
	var centre := _screen_point(joystick, joystick.size * 0.5)
	root.push_input(_touch(1, true, centre))
	await process_frame
	root.push_input(_drag(1, centre + Vector2(100, 0)))
	await process_frame

	_check(
		Input.get_action_strength(&"touch_move_right") > 0.95,
		"INPUT PATH: a viewport-delivered joystick drag drives touch_move_right",
	)

	root.push_input(_touch(1, false, centre + Vector2(100, 0)))
	await process_frame
	_check(
		is_zero_approx(Input.get_action_strength(&"touch_move_right")),
		"INPUT PATH: releasing the finger through the viewport clears touch_move_right",
	)

	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_interact_button_fires_through_the_viewport() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	var interact: Control = overlay.get_node("Interact")
	var point := _screen_point(interact, interact.size * 0.5)
	root.push_input(_touch(2, true, point))
	await process_frame

	_check(
		Input.is_action_pressed(&"touch_interact"),
		"INPUT PATH: the Interact button fires touch_interact through the viewport",
	)

	root.push_input(_touch(2, false, point))
	await process_frame
	_check(
		not Input.is_action_pressed(&"touch_interact"),
		"INPUT PATH: releasing the Interact button clears touch_interact",
	)

	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_hidden_overlay_does_not_drive_the_player() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")

	# The shipped state on a device without a touchscreen.
	overlay.visible = false
	await process_frame

	var joystick: Control = overlay.get_node("JoystickBase")
	var centre := _screen_point(joystick, joystick.size * 0.5)
	root.push_input(_touch(3, true, centre))
	await process_frame
	root.push_input(_drag(3, centre + Vector2(100, 0)))
	await process_frame

	_check(
		is_zero_approx(Input.get_action_strength(&"touch_move_right")),
		"INPUT PATH: a hidden overlay does not drive the touch movement actions",
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
