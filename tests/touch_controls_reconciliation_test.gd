extends SceneTree
## XH-002 reconciliation tests (requested in GitHub Issue #3):
##   1. HIGH-1  — freed-instance reference semantics vs is_instance_valid()
##   2. MEDIUM-2 — physical-key coexistence vs the synthetic Input.action_press() probe

const PlayerScene = preload("res://scenes/player.tscn")
const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _reconcile_high1_freed_instance()
	await _reconcile_medium2_physical_key()
	print("\nRECONCILIATION_PROBES: ", "PASS" if failures == 0 else "FAIL (%d)" % failures)
	quit(1 if failures > 0 else 0)


# --- HIGH-1 ------------------------------------------------------------------
func _reconcile_high1_freed_instance() -> void:
	var player := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(player)
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame

	var overlay: Control = layer.get_node("Overlay")
	# The shipped HUD is hidden when no touchscreen is available; this probe
	# exercises touch behaviour, so it must run with the HUD visible.
	overlay.visible = true
	await process_frame
	var cached: Variant = overlay.get("_player")
	_check(cached != null, "HIGH-1: the cached player is non-null while the player is alive")

	root.remove_child(player)
	player.free()
	await process_frame

	var freed: Variant = overlay.get("_player")
	var valid := is_instance_valid(freed)
	var compares_null := freed == null
	print("  HIGH-1 after free(): is_instance_valid = %s | == null = %s | != null = %s" % [valid, compares_null, freed != null])
	_check(not valid, "HIGH-1: is_instance_valid() reports the cached reference as invalid after free()")
	_check(compares_null, "HIGH-1: a freed instance compares equal to null in Godot 4 (so the old `!= null` guard suppressed the call)")

	# The HUD must recover: a new player must be picked up automatically.
	# Re-resolution is lazy — it happens on the next look drag, which is the
	# only moment the player reference is needed.
	var replacement := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(replacement)
	await process_frame

	var pivot: Node3D = replacement.get_node("CameraPivot")
	var initial_yaw := pivot.global_rotation.y
	var look_surface: Control = overlay.get_node("LookSurface")
	var start := look_surface.get_global_transform_with_canvas() * Vector2(look_surface.size.x * 0.65, look_surface.size.y * 0.4)
	var touch_event := InputEventScreenTouch.new()
	touch_event.index = 1
	touch_event.pressed = true
	touch_event.position = start
	overlay.call("_input", touch_event)
	var drag_event := InputEventScreenDrag.new()
	drag_event.index = 1
	drag_event.position = start + Vector2(40, 0)
	drag_event.relative = Vector2(40, 0)
	drag_event.screen_relative = Vector2(40, 0)
	overlay.call("_input", drag_event)
	await process_frame

	var re_resolved: Variant = overlay.get("_player")
	_check(is_instance_valid(re_resolved) and re_resolved == replacement, "HIGH-1: the next look drag re-resolves and picks up the replacement player")
	_check(not is_equal_approx(pivot.global_rotation.y, initial_yaw), "HIGH-1: the replacement player's camera receives the look delta")

	root.remove_child(layer)
	layer.free()
	root.remove_child(replacement)
	replacement.free()
	await process_frame


# --- MEDIUM-2 ----------------------------------------------------------------
func _reconcile_medium2_physical_key() -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	# A REAL key event through Godot's key pipeline, not a direct action_press().
	var key_event := InputEventKey.new()
	key_event.physical_keycode = KEY_W
	key_event.keycode = KEY_W
	key_event.pressed = true
	Input.parse_input_event(key_event)
	await process_frame

	var held_before := Input.is_action_pressed(&"move_forward")
	print("  MEDIUM-2: physical W key -> is_action_pressed(move_forward) = %s" % held_before)
	_check(held_before, "MEDIUM-2: a physical key press registers on the shared movement action")

	# Touch cleanup with a real key held (the new ownership-aware path).
	overlay.call("_cancel_all_touch_input")
	await process_frame
	var held_after_cleanup := Input.is_action_pressed(&"move_forward")
	print("  MEDIUM-2: after touch cleanup -> is_action_pressed(move_forward) = %s" % held_after_cleanup)
	_check(held_after_cleanup, "MEDIUM-2: touch cleanup does NOT cancel the physically held key")

	# For contrast: the OLD code path (an unconditional action_release) does cancel it.
	Input.action_release(&"move_forward")
	await process_frame
	_check(not Input.is_action_pressed(&"move_forward"), "MEDIUM-2: the old unconditional Input.action_release() DOES cancel the physically held key")

	var release_event := InputEventKey.new()
	release_event.physical_keycode = KEY_W
	release_event.keycode = KEY_W
	release_event.pressed = false
	Input.parse_input_event(release_event)
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
