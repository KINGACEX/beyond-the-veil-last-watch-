extends SceneTree
## Control hardening — concurrent movement, camera look and Interact through
## the real viewport input path. This complements direct-handler unit tests.

const PlayerScene = preload("res://scenes/player.tscn")
const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_three_finger_controls_coexist_through_viewport()
	await _test_focus_loss_clears_all_active_touch_owners()
	print("\nTOUCH_CONTROLS_MULTITOUCH_VIEWPORT_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
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


func _new_setup() -> Dictionary:
	var player := PlayerScene.instantiate() as BTVPlayerController
	root.add_child(player)
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame
	return {"player": player, "layer": layer, "overlay": overlay}


func _cleanup(setup: Dictionary) -> void:
	var layer: Node = setup.get("layer")
	var player: Node = setup.get("player")
	if is_instance_valid(layer):
		root.remove_child(layer)
		layer.free()
	if is_instance_valid(player):
		root.remove_child(player)
		player.free()
	for action_name in [&"touch_move_left", &"touch_move_right", &"touch_move_forward", &"touch_move_back", &"touch_interact"]:
		Input.action_release(action_name)
	await process_frame


func _test_three_finger_controls_coexist_through_viewport() -> void:
	var setup := await _new_setup()
	var overlay: Control = setup.get("overlay")
	var player: BTVPlayerController = setup.get("player")
	var joystick: Control = overlay.get_node("JoystickBase")
	var look_surface: Control = overlay.get_node("LookSurface")
	var interact: Control = overlay.get_node("Interact")
	var move_start := _screen_point(joystick, joystick.size * 0.5)
	var look_start := _screen_point(look_surface, Vector2(look_surface.size.x * 0.65, look_surface.size.y * 0.4))
	var interact_point := _screen_point(interact, interact.size * 0.5)
	var pivot: Node3D = player.get_node("CameraPivot")
	var initial_yaw := pivot.global_rotation.y

	# Finger 1 owns movement.
	root.push_input(_touch(1, true, move_start))
	await process_frame
	root.push_input(_drag(1, move_start + Vector2(90, 0)))
	await process_frame
	_check(Input.get_action_strength(&"touch_move_right") > 0.9, "MULTITOUCH: finger 1 owns joystick movement")

	# Finger 2 owns camera look without stealing finger 1.
	root.push_input(_touch(2, true, look_start))
	await process_frame
	root.push_input(_drag(2, look_start + Vector2(18, 0)))
	await process_frame
	_check(pivot.global_rotation.y < initial_yaw, "MULTITOUCH: finger 2 rotates the camera")
	_check(Input.get_action_strength(&"touch_move_right") > 0.9, "MULTITOUCH: camera look does not cancel movement")

	# Finger 3 presses the actual GUI Interact button.
	root.push_input(_touch(3, true, interact_point))
	await process_frame
	_check(Input.is_action_pressed(&"touch_interact"), "MULTITOUCH: finger 3 activates Interact through the GUI")
	_check(Input.get_action_strength(&"touch_move_right") > 0.9, "MULTITOUCH: Interact does not cancel movement")

	# Continue look while Interact and movement are both held.
	var yaw_before_second_drag := pivot.global_rotation.y
	root.push_input(_drag(2, look_start + Vector2(30, 0)))
	await process_frame
	_check(pivot.global_rotation.y < yaw_before_second_drag, "MULTITOUCH: look continues while Interact is held")
	_check(Input.is_action_pressed(&"touch_interact"), "MULTITOUCH: look movement does not release Interact")

	# Release only Interact. Other two fingers must retain ownership.
	root.push_input(_touch(3, false, interact_point))
	await process_frame
	_check(not Input.is_action_pressed(&"touch_interact"), "MULTITOUCH: releasing finger 3 clears only Interact")
	_check(Input.get_action_strength(&"touch_move_right") > 0.9, "MULTITOUCH: releasing Interact preserves joystick movement")

	# Release look. Movement must remain active.
	root.push_input(_touch(2, false, look_start + Vector2(30, 0)))
	await process_frame
	_check(Input.get_action_strength(&"touch_move_right") > 0.9, "MULTITOUCH: releasing camera-look finger preserves movement")

	# Release movement last.
	root.push_input(_touch(1, false, move_start + Vector2(90, 0)))
	await process_frame
	_check(is_zero_approx(Input.get_action_strength(&"touch_move_right")), "MULTITOUCH: releasing movement finger clears movement")
	_check(not Input.is_action_pressed(&"touch_interact"), "MULTITOUCH: all controls are idle after all three releases")
	await _cleanup(setup)


func _test_focus_loss_clears_all_active_touch_owners() -> void:
	var setup := await _new_setup()
	var overlay: Control = setup.get("overlay")
	var joystick: Control = overlay.get_node("JoystickBase")
	var look_surface: Control = overlay.get_node("LookSurface")
	var interact: Control = overlay.get_node("Interact")
	var move_start := _screen_point(joystick, joystick.size * 0.5)
	var look_start := _screen_point(look_surface, Vector2(look_surface.size.x * 0.65, look_surface.size.y * 0.4))
	var interact_point := _screen_point(interact, interact.size * 0.5)

	root.push_input(_touch(4, true, move_start))
	await process_frame
	root.push_input(_drag(4, move_start + Vector2(80, 0)))
	root.push_input(_touch(5, true, look_start))
	root.push_input(_touch(6, true, interact_point))
	await process_frame
	_check(Input.get_action_strength(&"touch_move_right") > 0.0, "CANCEL: movement is active before focus loss")
	_check(Input.is_action_pressed(&"touch_interact"), "CANCEL: Interact is active before focus loss")

	overlay.call("_notification", NOTIFICATION_APPLICATION_FOCUS_OUT)
	await process_frame
	_check(is_zero_approx(Input.get_action_strength(&"touch_move_right")), "CANCEL: focus loss clears movement action")
	_check(not Input.is_action_pressed(&"touch_interact"), "CANCEL: focus loss clears Interact action")
	_check(not overlay.get("_adapter").has_movement_finger(), "CANCEL: focus loss releases movement finger ownership")
	_check(not overlay.get("_adapter").has_look_finger(), "CANCEL: focus loss releases look finger ownership")
	await _cleanup(setup)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
