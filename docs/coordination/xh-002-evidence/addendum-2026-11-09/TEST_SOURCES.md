# Test sources — XH-003 acceptance test and audit probes

These scripts are published as **text**, not as runnable `.gd` files, for two reasons:

1. the evidence branch carries the **pre-XH-002** touch overlay (`scripts/touch_controls.gd` there has no
   joystick and no `_input` handler), so these scripts cannot run on this branch;
2. an evidence branch carries **documentation and scripts only — no game source**.

**They target `btv/agent-minimax-xh-002` @ `34c5af7089efa83a151fbaa79e44a070d1bf21c5`.**

To reproduce, check out that branch and copy the desired file into `tests/`:

```bash
git checkout btv/agent-minimax-xh-002
# save the block below as tests/<name>.gd
godot --headless --editor --path . --quit
godot --headless --path . --script res://tests/<name>.gd
```

Engine: `/workspace/.tools/godot` = `4.7.2.stable.official.ed1daf0bf` (headless).

All of them were executed in a scratch copy of the published tree
(`git archive btv/agent-minimax-xh-002`), never in the repository itself.

---

## tests/xh003_same_action_composition_test.gd

XH-003 acceptance test (PROPOSED — 12 assertions; 4 fail against the unfixed branch)

```gdscript
extends SceneTree
## XH-003 — Same-action input composition (PROPOSED acceptance test).
##
## The XH-002 action-ownership table stops touch cleanup from cancelling an
## action another source is holding. This suite pins the *composition* rule
## that XH-002 left open: while two sources drive the SAME action, releasing
## one must not destroy the other's contribution, in either ownership order.
##
## A real InputEventKey is used for the keyboard so the test exercises the
## same path a physical key takes, not a synthetic Input.action_press() call.

const TouchScene = preload("res://scenes/touch_controls.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _test_keyboard_released_first_joystick_survives()
	await _test_joystick_released_first_keyboard_survives()
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


## Drags the joystick "forward" (negative Y on screen drives move_forward).
func _drag_joystick_forward(overlay: Control, finger: int) -> void:
	var joystick: Control = overlay.get_node("JoystickBase")
	var center := _screen_point(joystick, joystick.size * 0.5)
	overlay.call("_input", _touch(finger, true, center))
	overlay.call("_input", _drag(finger, center + Vector2(0, -100)))


func _release_joystick(overlay: Control, finger: int) -> void:
	overlay.call("_input", _touch(finger, false, Vector2.ZERO))


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)


func _make_overlay() -> Control:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	return layer.get_node("Overlay")


func _teardown(layer: Node) -> void:
	root.remove_child(layer)
	layer.free()
	await process_frame


## Order A (the order named in the task):
##   hold W -> joystick also drives move_forward -> release the joystick
##   (W still held) -> forward movement must continue -> release W -> must stop.
func _test_keyboard_released_first_joystick_survives() -> void:
	print("\n[Order A] keyboard held, joystick released first")
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	# 1. A physical W key is held.
	await _key(true)
	_check(Input.is_action_pressed(&"move_forward"), "A1: the physical W key holds move_forward")

	# 2. The joystick also drives move_forward.
	_drag_joystick_forward(overlay, 1)
	await process_frame
	_check(Input.get_action_strength(&"move_forward") > 0.0, "A2: the joystick also drives move_forward")

	# 3. The joystick is released while W remains held.
	_release_joystick(overlay, 1)
	await process_frame

	# 4. Forward movement must continue.
	_check(
		Input.is_action_pressed(&"move_forward"),
		"A4: releasing the joystick does not stop forward movement while W is held",
	)
	_check(
		Input.get_action_strength(&"move_forward") > 0.0,
		"A4: forward movement keeps a non-zero strength while W is held",
	)

	# 5. W is then released.
	await _key(false)
	await process_frame

	# 6. Forward movement must stop.
	_check(not Input.is_action_pressed(&"move_forward"), "A6: forward movement stops after W is released")
	_check(
		is_zero_approx(Input.get_action_strength(&"move_forward")),
		"A6: forward movement strength reaches zero after W is released",
	)

	await _teardown(layer)


## Order B (the reverse ownership order):
##   joystick holds move_forward -> W is pressed -> W is released while the
##   joystick is still down -> forward movement must STILL continue, because
##   the joystick has not been lifted.
func _test_joystick_released_first_keyboard_survives() -> void:
	print("\n[Order B] joystick held, keyboard released first")
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	# The joystick drives move_forward and stays down.
	_drag_joystick_forward(overlay, 1)
	await process_frame
	_check(Input.get_action_strength(&"move_forward") > 0.0, "B1: the joystick drives move_forward")

	# W is pressed as well.
	await _key(true)
	await process_frame
	_check(Input.is_action_pressed(&"move_forward"), "B2: the physical W key joins the held action")

	# W is released while the joystick is STILL down.
	await _key(false)
	await process_frame

	# The joystick has not been lifted, so forward movement must continue.
	_check(
		Input.is_action_pressed(&"move_forward"),
		"B4: releasing W does not stop forward movement while the joystick is still held",
	)
	_check(
		Input.get_action_strength(&"move_forward") > 0.0,
		"B4: the joystick's forward contribution survives the key release",
	)

	# Lifting the joystick finally stops movement.
	_release_joystick(overlay, 1)
	await process_frame
	_check(not Input.is_action_pressed(&"move_forward"), "B6: forward movement stops once the joystick is lifted")

	await _teardown(layer)
```

---

## tests/audit_input_semantics_probe.gd

Audit probe A — engine action-strength semantics, overlay release correctness, keyboard+touch coexistence, zero-deadzone

```gdscript
extends SceneTree
## AUDIT PROBE (scratch copy only — the repository is not modified).
## Question: does the XH-002 action-ownership scheme let keyboard and touch
## contribute to the SAME movement action without interfering?

const TouchScene = preload("res://scenes/touch_controls.tscn")

var fails := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await _probe_a_engine_semantics()
	await _probe_b_overlay_decreasing_strength()
	await _probe_c_keyboard_first_then_touch()
	await _probe_d_touch_first_then_keyboard()
	await _probe_e_zero_deadzone()
	print("\nAUDIT_PROBE done. expectations recorded per probe.")
	quit(0)


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  PASS: ", label)
	else:
		fails += 1
		printerr("  FAIL: ", label)


func _key(pressed: bool) -> void:
	var e := InputEventKey.new()
	e.physical_keycode = KEY_W
	e.keycode = KEY_W
	e.pressed = pressed
	Input.parse_input_event(e)
	await process_frame


func _probe_a_engine_semantics() -> void:
	print("\n[A] Godot action-strength semantics")
	Input.action_press(&"move_forward", 0.8)
	await process_frame
	var high: float = Input.get_action_strength(&"move_forward")
	Input.action_press(&"move_forward", 0.3)
	await process_frame
	var low: float = Input.get_action_strength(&"move_forward")
	print("  press(0.8) -> strength %.3f | press(0.3) -> strength %.3f" % [high, low])
	print("  => engine takes MAX on press: %s" % (low >= high))
	Input.action_release(&"move_forward")
	await process_frame


func _probe_b_overlay_decreasing_strength() -> void:
	print("\n[B] overlay: joystick strength decreases, then finger lifts")
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	overlay.call("_set_action_strength", &"move_forward", 0.8)
	await process_frame
	var s1: float = Input.get_action_strength(&"move_forward")
	overlay.call("_set_action_strength", &"move_forward", 0.3)
	await process_frame
	var s2: float = Input.get_action_strength(&"move_forward")
	overlay.call("_set_action_strength", &"move_forward", 0.0)
	await process_frame
	var pressed: bool = Input.is_action_pressed(&"move_forward")
	var s3: float = Input.get_action_strength(&"move_forward")
	print("  after 0.8 -> %.3f | after 0.3 -> %.3f | after release -> pressed=%s strength=%.3f" % [s1, s2, pressed, s3])
	_check(s2 < s1, "[B] a LOWER analog strength is applied to the action (movement can decelerate)")
	_check(not pressed, "[B] releasing the joystick actually releases the action (no stuck movement)")

	root.remove_child(layer)
	layer.free()
	await process_frame


func _probe_c_keyboard_first_then_touch() -> void:
	print("\n[C] physical key held FIRST, then touch drives the same action")
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	await _key(true)
	var k_before: bool = Input.is_action_pressed(&"move_forward")
	var k_strength: float = Input.get_action_strength(&"move_forward")

	overlay.call("_set_action_strength", &"move_forward", 0.5)
	await process_frame
	var during: float = Input.get_action_strength(&"move_forward")

	overlay.call("_set_action_strength", &"move_forward", 0.0)
	await process_frame
	var after: bool = Input.is_action_pressed(&"move_forward")
	var after_strength: float = Input.get_action_strength(&"move_forward")
	print("  key held -> pressed=%s strength=%.3f | during touch -> %.3f | after touch release -> pressed=%s strength=%.3f"
		% [k_before, k_strength, during, after, after_strength])
	_check(k_before, "[C] the physical key registers on move_forward")
	_check(after, "[C] touch release does NOT cancel the keyboard-held action")

	await _key(false)
	root.remove_child(layer)
	layer.free()
	await process_frame


func _probe_d_touch_first_then_keyboard() -> void:
	print("\n[D] touch drives the action FIRST, then a physical key is pressed")
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	overlay.call("_set_action_strength", &"move_forward", 0.5)
	await process_frame
	await _key(true)
	var during: float = Input.get_action_strength(&"move_forward")
	var pressed_during: bool = Input.is_action_pressed(&"move_forward")

	overlay.call("_set_action_strength", &"move_forward", 0.0)
	await process_frame
	var after: bool = Input.is_action_pressed(&"move_forward")
	print("  during -> pressed=%s strength=%.3f | after touch release -> pressed=%s" % [pressed_during, during, after])
	_check(pressed_during, "[D] the action stays pressed while both sources are active")
	_check(after, "[D] touch release does NOT cancel the keyboard-held action")

	await _key(false)
	root.remove_child(layer)
	layer.free()
	await process_frame


func _probe_e_zero_deadzone() -> void:
	print("\n[E] InputMap deadzone on movement actions")
	Input.action_press(&"move_right", 0.1)
	await process_frame
	var v: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_back", &"move_forward")
	print("  get_vector with raw strength 0.1 -> %.3f" % v.x)
	_check(absf(v.x - 0.1) < 0.001, "[E] the InputMap deadzone is 0.0 (no second deadzone applied on top of the adapter's)")
	Input.action_release(&"move_right")
	await process_frame
```

---

## tests/audit_simultaneous_probe.gd

Audit probe B — the decisive same-action test: masking and the key-release stall

```gdscript
extends SceneTree
## AUDIT PROBE 2 (scratch copy only).
## Can keyboard and touch contribute to the SAME action simultaneously?

const TouchScene = preload("res://scenes/touch_controls.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame

	print("\n[F] key held + touch on the same action, then the KEY is released (touch still down)")
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	var k := InputEventKey.new()
	k.physical_keycode = KEY_W
	k.keycode = KEY_W
	k.pressed = true
	Input.parse_input_event(k)
	await process_frame
	print("   key held            -> strength %.3f pressed=%s" % [Input.get_action_strength(&"move_forward"), Input.is_action_pressed(&"move_forward")])

	overlay.call("_set_action_strength", &"move_forward", 0.5)
	await process_frame
	print("   + touch 0.5         -> strength %.3f pressed=%s" % [Input.get_action_strength(&"move_forward"), Input.is_action_pressed(&"move_forward")])

	var up := InputEventKey.new()
	up.physical_keycode = KEY_W
	up.keycode = KEY_W
	up.pressed = false
	Input.parse_input_event(up)
	await process_frame
	print("   key released        -> strength %.3f pressed=%s   <-- does the touch contribution survive?" % [Input.get_action_strength(&"move_forward"), Input.is_action_pressed(&"move_forward")])

	overlay.call("_set_action_strength", &"move_forward", 0.0)
	await process_frame
	print("   touch released      -> strength %.3f pressed=%s" % [Input.get_action_strength(&"move_forward"), Input.is_action_pressed(&"move_forward")])

	print("\n[G] is the touch contribution ADDED to the keyboard, or MASKED by it?")
	Input.action_release(&"move_forward")
	await process_frame
	var k2 := InputEventKey.new()
	k2.physical_keycode = KEY_W
	k2.keycode = KEY_W
	k2.pressed = true
	Input.parse_input_event(k2)
	await process_frame
	overlay.call("_set_action_strength", &"move_forward", 0.5)
	await process_frame
	var v: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_back", &"move_forward")
	var strength: float = Input.get_action_strength(&"move_forward")
	print("   key(1.0) + touch(0.5) -> effective strength %.3f, vector.y %.3f  (additive would be 1.0/1.0; masked-by-key is 1.0)" % [strength, v.y])
	print("   => touch contribution is %s" % ("MASKED (keyboard wins the single slot)" if strength > 0.99 else "combined"))

	print("\n[H] focus-loss cleanup while the keyboard is held")
	var k3 := InputEventKey.new()
	k3.physical_keycode = KEY_W
	k3.keycode = KEY_W
	k3.pressed = true
	Input.parse_input_event(k3)
	await process_frame
	overlay.call("_cancel_all_touch_input")
	await process_frame
	print("   after _cancel_all_touch_input -> pressed=%s strength=%.3f  (keyboard must survive)" % [Input.is_action_pressed(&"move_forward"), Input.get_action_strength(&"move_forward")])

	var up2 := InputEventKey.new()
	up2.physical_keycode = KEY_W
	up2.keycode = KEY_W
	up2.pressed = false
	Input.parse_input_event(up2)
	await process_frame

	root.remove_child(layer)
	layer.free()
	await process_frame
	quit(0)
```

---

## tests/xh003_diagnostic.gd

XH-003 diagnostic — deflection vs owned strength vs outcome table

```gdscript
extends SceneTree
## XH-003 diagnostic — why the same-action release misbehaves.
## Prints the overlay's recorded ownership strength, the engine's effective
## strength and the outcome, for a range of joystick deflections.

const TouchScene = preload("res://scenes/touch_controls.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	print("\n=== ownership strength vs engine strength vs outcome ===")
	print("%-12s %-14s %-14s %-10s" % ["deflection", "owned_strength", "effective", "survives?"])
	for deflection in [20.0, 40.0, 60.0, 63.0, 70.0, 100.0, 140.0]:
		await _case(deflection)
	quit(0)


func _case(deflection: float) -> void:
	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	# A physical W key is held.
	var key := InputEventKey.new()
	key.physical_keycode = KEY_W
	key.keycode = KEY_W
	key.pressed = true
	Input.parse_input_event(key)
	await process_frame

	# The joystick is dragged forward by the given deflection.
	var joystick: Control = overlay.get_node("JoystickBase")
	var center: Vector2 = joystick.get_global_transform_with_canvas() * (joystick.size * 0.5)
	var press := InputEventScreenTouch.new()
	press.index = 1
	press.pressed = true
	press.position = center
	overlay.call("_input", press)
	var drag := InputEventScreenDrag.new()
	drag.index = 1
	drag.position = center + Vector2(0, -deflection)
	drag.relative = Vector2(0, -deflection)
	overlay.call("_input", drag)
	await process_frame

	var owned: Variant = (overlay.get("_owned_actions") as Dictionary).get(&"move_forward", null)
	var effective: float = Input.get_action_strength(&"move_forward")

	# The joystick is released while W remains held.
	var release := InputEventScreenTouch.new()
	release.index = 1
	release.pressed = false
	release.position = Vector2.ZERO
	overlay.call("_input", release)
	await process_frame

	var survives: bool = Input.is_action_pressed(&"move_forward")
	print("%-12s %-14s %-14s %-10s" % [
		"%.0f px" % deflection,
		("%.3f" % owned) if owned != null else "none",
		"%.3f" % effective,
		"yes" if survives else "NO",
	])

	# Reset for the next case.
	var up := InputEventKey.new()
	up.physical_keycode = KEY_W
	up.keycode = KEY_W
	up.pressed = false
	Input.parse_input_event(up)
	await process_frame
	root.remove_child(layer)
	layer.free()
	await process_frame
```

---

## tests/xh003_interact_probe.gd

XH-003 diagnostic — the shared `interact` action

```gdscript
extends SceneTree
## XH-003 diagnostic 2 — does the same one-slot defect reach the shared
## `interact` action (touch Interact button + keyboard E)?

const TouchScene = preload("res://scenes/touch_controls.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	await process_frame

	var layer := TouchScene.instantiate()
	root.add_child(layer)
	await process_frame
	var overlay: Control = layer.get_node("Overlay")
	overlay.visible = true
	await process_frame

	# Keyboard E is held (physical key event).
	var down := InputEventKey.new()
	down.physical_keycode = KEY_E
	down.keycode = KEY_E
	down.pressed = true
	Input.parse_input_event(down)
	await process_frame
	print("\n  E held           -> interact pressed=%s strength=%.3f" % [Input.is_action_pressed(&"interact"), Input.get_action_strength(&"interact")])

	# The touch Interact button is pressed (what button_down does).
	overlay.call("_press_action", &"interact")
	await process_frame
	print("  + touch button   -> interact pressed=%s strength=%.3f" % [Input.is_action_pressed(&"interact"), Input.get_action_strength(&"interact")])

	# The touch Interact button is released while E is still held.
	overlay.call("_release_action", &"interact")
	await process_frame
	var survived: bool = Input.is_action_pressed(&"interact")
	print("  touch released   -> interact pressed=%s strength=%.3f  <-- E should still be held" % [survived, Input.get_action_strength(&"interact")])
	print("  RESULT: %s" % ("keyboard survives" if survived else "KEYBOARD E WAS CANCELLED BY THE TOUCH BUTTON"))

	var up := InputEventKey.new()
	up.physical_keycode = KEY_E
	up.keycode = KEY_E
	up.pressed = false
	Input.parse_input_event(up)
	await process_frame
	root.remove_child(layer)
	layer.free()
	await process_frame
	quit(0)
```

