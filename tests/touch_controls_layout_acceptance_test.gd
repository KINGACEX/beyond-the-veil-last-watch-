extends SceneTree
## Validates control geometry at representative viewport shapes. This is a
## layout regression check, not physical-device safe-area certification.

const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0
const VIEWPORTS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(2400, 1080),
	Vector2i(1080, 2400),
	Vector2i(720, 1280),
	Vector2i(640, 360),
]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	var joystick: Control = overlay.get_node("JoystickBase")
	var interact: Control = overlay.get_node("Interact")
	var look_surface: Control = overlay.get_node("LookSurface")

	for viewport_size in VIEWPORTS:
		root.size = viewport_size
		await process_frame
		await process_frame
		_check_control_inside(joystick, overlay, "LAYOUT %s: joystick remains inside overlay" % viewport_size)
		_check_control_inside(interact, overlay, "LAYOUT %s: Interact remains inside overlay" % viewport_size)
		_check(
			not Rect2(joystick.position, joystick.size).intersects(Rect2(interact.position, interact.size)),
			"LAYOUT %s: joystick and Interact hit areas do not overlap" % viewport_size,
		)
		_check(
			interact.size.x >= 88.0 and interact.size.y >= 72.0,
			"LAYOUT %s: Interact retains its authored minimum hit-area dimensions" % viewport_size,
		)
		var interact_center := interact.get_global_transform_with_canvas() * (interact.size * 0.5)
		var look_local := look_surface.get_global_transform_with_canvas().affine_inverse() * interact_center
		_check(
			Rect2(Vector2.ZERO, look_surface.size).has_point(look_local),
			"LAYOUT %s: Interact remains in the look region's bounds and must be explicitly excluded from look ownership" % viewport_size,
		)

	root.size = Vector2i(1280, 720)
	await process_frame
	root.remove_child(layer)
	layer.free()
	print("\nTOUCH_CONTROLS_LAYOUT_ACCEPTANCE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check_control_inside(control: Control, parent: Control, label: String) -> void:
	var rect := Rect2(control.position, control.size)
	var parent_rect := Rect2(Vector2.ZERO, parent.size)
	_check(
		parent_rect.encloses(rect),
		"%s (control=%s parent=%s)" % [label, rect, parent_rect],
	)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
