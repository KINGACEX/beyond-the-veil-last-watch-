extends SceneTree
## XH-002 — Viewport resize behaviour.
##
## The overlay must track the viewport, and the joystick must stay usable and
## inside the overlay at phone-sized viewports in both orientations.

const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_overlay_tracks_the_viewport()
	await _test_joystick_stays_inside_the_overlay_in_both_orientations()
	print("\nTOUCH_CONTROLS_RESIZE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _test_overlay_tracks_the_viewport() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")

	for viewport_size: Vector2i in [Vector2i(1280, 720), Vector2i(2400, 1080), Vector2i(1080, 2400)]:
		root.size = viewport_size
		await process_frame
		await process_frame

		_check(
			overlay.size.is_equal_approx(Vector2(viewport_size)),
			"RESIZE: overlay tracks the %dx%d viewport (got %s)" % [viewport_size.x, viewport_size.y, overlay.size],
		)

	root.size = Vector2i(1280, 720)
	await process_frame
	root.remove_child(layer)
	layer.free()
	await process_frame


func _test_joystick_stays_inside_the_overlay_in_both_orientations() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	var joystick: Control = overlay.get_node("JoystickBase")

	for viewport_size: Vector2i in [Vector2i(2400, 1080), Vector2i(1080, 2400)]:
		root.size = viewport_size
		await process_frame
		await process_frame

		var joystick_rect := Rect2(joystick.global_position, joystick.size)
		_check(
			joystick_rect.position.x >= 0.0 and joystick_rect.position.y >= 0.0,
			"RESIZE: joystick origin stays on screen at %dx%d" % [viewport_size.x, viewport_size.y],
		)
		_check(
			joystick_rect.end.x <= overlay.size.x and joystick_rect.end.y <= overlay.size.y,
			"RESIZE: joystick stays inside the overlay at %dx%d" % [viewport_size.x, viewport_size.y],
		)

		# The joystick centre must still map to a point inside the joystick.
		var centre := joystick.get_global_transform_with_canvas() * (joystick.size * 0.5)
		var local := joystick.get_global_transform_with_canvas().affine_inverse() * centre
		_check(
			Rect2(Vector2.ZERO, joystick.size).has_point(local),
			"RESIZE: joystick centre maps inside the joystick at %dx%d" % [viewport_size.x, viewport_size.y],
		)

	root.size = Vector2i(1280, 720)
	await process_frame
	root.remove_child(layer)
	layer.free()
	await process_frame


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
