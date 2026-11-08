extends SceneTree

const PlayerScene = preload("res://scenes/player.tscn")
const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_virtual_joystick_drives_shared_movement_actions()
	await _test_look_surface_rotates_camera_without_cancelling_movement()
	await _test_interact_button_area_is_excluded_from_camera_look()
	await _test_focus_loss_releases_all_touch_input()
	await _test_scene_teardown_releases_movement_actions()
	await _test_legacy_directional_controls_remain_available()
	if failures == 0:
		print("TOUCH_CONTROLS_INTEGRATION_TESTS: PASS")
		quit(0)
	else:
		printerr("TOUCH_CONTROLS_INTEGRATION_TESTS: FAIL (", failures, " failures)")
		quit(1)


func _new_setup() -> Dictionary:
	var player := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(player)
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	return {
		"player": player,
		"layer": layer,
		"overlay": layer.get_node("Overlay")
	}


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
	return event


func _cleanup(setup: Dictionary) -> void:
	var layer: Node = setup.get("layer")
	var player: Node = setup.get("player")
	if is_instance_valid(layer):
		root.remove_child(layer)
		layer.free()
	if is_instance_valid(player):
		root.remove_child(player)
		player.free()
	for action_name in [&"move_left", &"move_right", &"move_forward", &"move_back", &"interact"]:
		Input.action_release(action_name)


func _test_virtual_joystick_drives_shared_movement_actions() -> void:
	var setup := _new_setup()
	await process_frame
	var overlay: Control = setup.get("overlay")
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	overlay.call("_input", _touch(1, true, center))
	overlay.call("_input", _drag(1, center + Vector2(100, 0)))
	_check(Input.get_action_strength("move_right") > 0.95, "Right joystick drag feeds the shared move_right action")
	_check(is_zero_approx(Input.get_action_strength("move_left")), "Right joystick drag does not activate move_left")
	overlay.call("_input", _touch(1, false, center + Vector2(100, 0)))
	_check(is_zero_approx(Input.get_action_strength("move_right")), "Joystick release clears the movement action")
	_cleanup(setup)


func _test_look_surface_rotates_camera_without_cancelling_movement() -> void:
	var setup := _new_setup()
	await process_frame
	var player: CharacterBody3D = setup.get("player")
	var overlay: Control = setup.get("overlay")
	var joystick: Control = overlay.get_node("JoystickBase")
	var look_surface: Control = overlay.get_node("LookSurface")
	var move_center := _screen_point(joystick, joystick.size * 0.5)
	var look_start := _screen_point(look_surface, Vector2(look_surface.size.x * 0.65, look_surface.size.y * 0.4))
	var pivot: Node3D = player.get_node("CameraPivot")
	var initial_yaw := pivot.global_rotation.y
	overlay.call("_input", _touch(2, true, move_center))
	overlay.call("_input", _touch(3, true, look_start))
	overlay.call("_input", _drag(2, move_center + Vector2(50, 0)))
	overlay.call("_input", _drag(3, look_start + Vector2(12, 0)))
	_check(Input.get_action_strength("move_right") > 0.0, "Movement finger remains active during camera look")
	_check(pivot.global_rotation.y < initial_yaw, "Independent look finger rotates the camera")
	overlay.call("_input", _touch(3, false, look_start + Vector2(12, 0)))
	_check(Input.get_action_strength("move_right") > 0.0, "Releasing the look finger does not cancel movement")
	overlay.call("_input", _touch(2, false, move_center + Vector2(50, 0)))
	_check(is_zero_approx(Input.get_action_strength("move_right")), "Movement ends only when its own finger releases")
	_cleanup(setup)


func _test_interact_button_area_is_excluded_from_camera_look() -> void:
	var setup := _new_setup()
	await process_frame
	var overlay: Control = setup.get("overlay")
	var interact: Control = overlay.get_node("Interact")
	var look_surface: Control = overlay.get_node("LookSurface")
	var button_point := _screen_point(interact, interact.size * 0.5)
	var button_local := look_surface.get_global_transform_with_canvas().affine_inverse() * button_point
	_check(Rect2(Vector2.ZERO, look_surface.size).has_point(button_local), "Interact button is positioned within the camera-look region")
	overlay.call("_input", _touch(4, true, button_point))
	overlay.call("_input", _drag(4, button_point + Vector2(20, 0)))
	var player: CharacterBody3D = setup.get("player")
	var pivot: Node3D = player.get_node("CameraPivot")
	_check(is_zero_approx(pivot.global_rotation.y), "Interact button region does not start camera-look tracking")
	overlay.call("_input", _touch(4, false, button_point + Vector2(20, 0)))
	_cleanup(setup)


func _test_focus_loss_releases_all_touch_input() -> void:
	var setup := _new_setup()
	await process_frame
	var overlay: Control = setup.get("overlay")
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	overlay.call("_input", _touch(5, true, center))
	overlay.call("_input", _drag(5, center + Vector2(80, 0)))
	_check(Input.get_action_strength("move_right") > 0.0, "Movement is active before focus loss")
	overlay.call("_notification", NOTIFICATION_APPLICATION_FOCUS_OUT)
	_check(is_zero_approx(Input.get_action_strength("move_right")), "Focus loss releases analog movement actions")
	_cleanup(setup)


func _test_scene_teardown_releases_movement_actions() -> void:
	var setup := _new_setup()
	await process_frame
	var overlay: Control = setup.get("overlay")
	var layer: Node = setup.get("layer")
	var player: Node = setup.get("player")
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	overlay.call("_input", _touch(6, true, center))
	overlay.call("_input", _drag(6, center + Vector2(80, 0)))
	_check(Input.get_action_strength("move_right") > 0.0, "Movement is active before touch scene teardown")
	root.remove_child(layer)
	layer.free()
	_check(is_zero_approx(Input.get_action_strength("move_right")), "Touch scene teardown releases movement actions")
	root.remove_child(player)
	player.free()


func _test_legacy_directional_controls_remain_available() -> void:
	var player := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(player)
	var layer := TouchScene.instantiate()
	var overlay: Control = layer.get_node("Overlay")
	overlay.set("use_analog_touch_controls", false)
	root.add_child(layer)
	await process_frame
	_check(overlay.get_node("MovePad").visible, "Legacy directional pad remains available as a fallback")
	_check(not overlay.get_node("JoystickBase").visible, "Virtual joystick can be disabled for fallback mode")
	_check(not overlay.get_node("LookSurface").visible, "Touch-look surface can be disabled for fallback mode")
	_cleanup({"player": player, "layer": layer})


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
