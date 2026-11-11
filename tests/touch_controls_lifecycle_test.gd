extends SceneTree
## XH-002 — Touch HUD lifecycle.
##
## The HUD must keep working when the player is created after it, and must
## follow the player when the player is replaced (respawn / scene change).

const PlayerScene = preload("res://scenes/player.tscn")
const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_look_works_when_player_arrives_after_the_hud()
	await _test_look_follows_a_replaced_player()
	print("\nTOUCH_CONTROLS_LIFECYCLE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _screen_point(control: Control, local_point: Vector2) -> Vector2:
	return control.get_global_transform_with_canvas() * local_point


func _touch(index: int, pressed: bool, position: Vector2) -> InputEventScreenTouch:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.pressed = pressed
	event.position = position
	return event


func _drag(index: int, position: Vector2, screen_delta: Vector2 = Vector2.ZERO) -> InputEventScreenDrag:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = position
	event.relative = position
	event.screen_relative = screen_delta
	return event


func _look_drag(overlay: Control, finger: int) -> void:
	var look_surface: Control = overlay.get_node("LookSurface")
	var start := _screen_point(look_surface, Vector2(look_surface.size.x * 0.65, look_surface.size.y * 0.4))
	overlay.call("_input", _touch(finger, true, start))
	overlay.call("_input", _drag(finger, start + Vector2(40, 0), Vector2(40, 0)))
	overlay.call("_input", _touch(finger, false, start + Vector2(40, 0)))


func _test_look_works_when_player_arrives_after_the_hud() -> void:
	# The HUD comes first: there is no player in the group yet.
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame

	var overlay: Control = layer.get_node("Overlay")
	# Simulate a touchscreen device: the shipped overlay is hidden without one.
	overlay.visible = true
	await process_frame
	_check(overlay.get("_player") == null, "LIFECYCLE: the HUD starts with no player resolved")

	# The player arrives afterwards, as it would on a later scene load.
	var player := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(player)
	await process_frame

	var pivot: Node3D = player.get_node("CameraPivot")
	var initial_yaw := pivot.global_rotation.y
	_look_drag(overlay, 1)
	await process_frame

	_check(
		not is_equal_approx(pivot.global_rotation.y, initial_yaw),
		"LIFECYCLE: camera look works once the player appears after the HUD",
	)

	root.remove_child(layer)
	layer.free()
	root.remove_child(player)
	player.free()
	await process_frame


func _test_look_follows_a_replaced_player() -> void:
	var first_player := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(first_player)
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame

	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame
	_check(overlay.get("_player") != null, "LIFECYCLE: the HUD resolves the player when it is present")

	# The player is destroyed and replaced, as on a respawn.
	root.remove_child(first_player)
	first_player.free()
	var second_player := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(second_player)
	await process_frame

	var pivot: Node3D = second_player.get_node("CameraPivot")
	var initial_yaw := pivot.global_rotation.y
	_look_drag(overlay, 2)
	await process_frame

	_check(
		not is_equal_approx(pivot.global_rotation.y, initial_yaw),
		"LIFECYCLE: camera look follows the replacement player",
	)

	root.remove_child(layer)
	layer.free()
	root.remove_child(second_player)
	second_player.free()
	await process_frame


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
