extends SceneTree
## Verifies the first traversal mechanic: a grounded jump and one bounded mid-air jump.

const LabScene = preload("res://scenes/movement_physics_lab.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_clear_jump()
	root.size = Vector2i(1280, 720)
	await process_frame
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	var player := lab.get_node("Player") as BTVPlayerController
	for _tick in range(4):
		await physics_frame
	_check(player.is_on_floor(), "JUMP: player begins grounded")

	Input.action_press(&"jump")
	await physics_frame
	Input.action_release(&"jump")
	var first_jump_velocity := player.velocity.y
	_check(first_jump_velocity > 0.0, "JUMP: grounded input produces upward velocity")
	for _tick in range(5):
		await physics_frame
	var before_second_jump := player.velocity.y
	Input.action_press(&"jump")
	await physics_frame
	Input.action_release(&"jump")
	var second_jump_velocity := player.velocity.y
	_check(
		second_jump_velocity > before_second_jump,
		"JUMP: one mid-air input produces a second upward impulse",
	)

	for _tick in range(2):
		await physics_frame
	var after_second_jump := player.velocity.y
	Input.action_press(&"jump")
	await physics_frame
	Input.action_release(&"jump")
	_check(
		player.velocity.y < after_second_jump,
		"JUMP: additional mid-air input cannot trigger a third jump",
	)

	_clear_jump()
	root.remove_child(lab)
	lab.free()
	await process_frame
	print("\\nTRAVERSAL_JUMP_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _clear_jump() -> void:
	Input.action_release(&"jump")
	Input.action_release(&"touch_jump")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
