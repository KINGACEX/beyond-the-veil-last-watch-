extends SceneTree
## Neutral-lab collision probes: wall blocking, doorway/corridor clearance and ramp floor contact.

const LabScene = preload("res://scenes/movement_physics_lab.tscn")

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_clear_actions()
	root.size = Vector2i(1280, 720)
	await process_frame
	var lab := LabScene.instantiate()
	root.add_child(lab)
	await process_frame
	var player := lab.get_node("Player") as BTVPlayerController
	for _tick in range(3):
		await physics_frame

	await _test_front_wall_blocks_player(player)
	await _test_doorway_clearance(player)
	await _test_corridor_clearance(player)
	await _test_ramp_keeps_ground_contact(player)

	_clear_actions()
	root.remove_child(lab)
	lab.free()
	await process_frame
	print("\nMOVEMENT_PHYSICS_LAB_COLLISION_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _reset_player(player: BTVPlayerController, spawn: Vector3) -> void:
	_clear_actions()
	player.velocity = Vector3.ZERO
	player.global_position = spawn
	player.rotation = Vector3.ZERO
	for _tick in range(3):
		await physics_frame


func _test_front_wall_blocks_player(player: BTVPlayerController) -> void:
	await _reset_player(player, Vector3(0, 0, -8))
	Input.action_press(&"move_forward")
	for _tick in range(150):
		await physics_frame
	_check(
		player.global_position.z > -11.0,
		"COLLISION: front wall prevents the player from passing through",
	)
	_check(
		player.is_on_wall(),
		"COLLISION: CharacterBody3D reports wall contact at the barrier",
	)
	_clear_actions()


func _test_doorway_clearance(player: BTVPlayerController) -> void:
	await _reset_player(player, Vector3(8.45, 0, -7))
	Input.action_press(&"move_forward")
	for _tick in range(120):
		await physics_frame
	_check(
		player.global_position.z < -11.5,
		"COLLISION: player passes through the authored 1.4 m doorway opening",
	)
	_check(
		absf(player.global_position.x - 8.45) < 0.15,
		"COLLISION: doorway passage does not push the player sideways",
	)
	_clear_actions()


func _test_corridor_clearance(player: BTVPlayerController) -> void:
	await _reset_player(player, Vector3(8.05, 0, 14))
	Input.action_press(&"move_forward")
	for _tick in range(180):
		await physics_frame
	print("CORRIDOR DIAGNOSTIC: position=%s velocity=%s" % [player.global_position, player.velocity])
	_check(
		player.global_position.z < 6.0,
		"COLLISION: player traverses the narrow parallel-wall corridor",
	)
	_check(
		absf(player.global_position.x - 8.05) < 0.15,
		"COLLISION: corridor traversal preserves lateral alignment",
	)
	_clear_actions()


func _test_ramp_keeps_ground_contact(player: BTVPlayerController) -> void:
	await _reset_player(player, Vector3(-15, 0, -4.5))
	Input.action_press(&"move_forward")
	for _tick in range(60):
		await physics_frame
	print("RAMP DIAGNOSTIC: position=%s velocity=%s grounded=%s" % [player.global_position, player.velocity, player.is_on_floor()])
	_check(
		player.global_position.z < -7.5,
		"COLLISION: player advances onto the gentle ramp",
	)
	_check(
		player.global_position.y > 0.25,
		"COLLISION: player gains height while following the ramp",
	)
	_check(
		player.is_on_floor(),
		"COLLISION: player remains grounded on the gentle ramp",
	)
	_clear_actions()


func _clear_actions() -> void:
	for action_name in [&"move_forward", &"move_back", &"move_left", &"move_right"]:
		Input.action_release(action_name)
	for action_name in [&"touch_move_forward", &"touch_move_back", &"touch_move_left", &"touch_move_right"]:
		Input.action_release(action_name)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
