extends SceneTree
## Acceptance checks for the first playable exploration greybox and its complete field-note loop.

const ExplorationScene = preload("res://scenes/exploration_prototype.tscn")
const OBSERVATION_NAMES := [
	"Clearing_FieldNote",
	"Pond_FieldNote",
	"Ridge_FieldNote",
	"Forest_FieldNote",
]
var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_clear_player_actions()
	var journal_path := "user://btv_exploration_journal.cfg"
	if FileAccess.file_exists(journal_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(journal_path))
	var world := ExplorationScene.instantiate()
	root.add_child(world)
	await process_frame
	await physics_frame

	_check(world.get_node_or_null("Player") is BTVPlayerController, "EXPLORATION: player controller is present")
	_check(world.get_node_or_null("TouchControls") is CanvasLayer, "EXPLORATION: touch controls are integrated")
	_check(world.get_node_or_null("HUD/Status") is Label, "EXPLORATION: control guidance HUD exists")
	_check(world.get_node_or_null("HUD/InteractionToast") is Label, "EXPLORATION: interaction feedback HUD exists")
	_check(world.get_node_or_null("ExplorationWorldEnvironment") is WorldEnvironment, "EXPLORATION: world environment exists")
	_check(world.get_node_or_null("Ground") is StaticBody3D, "EXPLORATION: collision ground exists")
	_check(world.get_node_or_null("Pond_Surface_VisualOnly") is MeshInstance3D, "EXPLORATION: pond visual landmark exists")
	_check(world.get_node_or_null("RockShelf") is StaticBody3D, "EXPLORATION: raised navigation landmark has collision")
	_check(world.get_node_or_null("Tree_00") is Node3D, "EXPLORATION: vegetation proxy exists")

	var player := world.get_node("Player") as BTVPlayerController
	var journal := world.get("_journal") as BTVExplorationJournal
	var seen_ids: Dictionary = {}
	for observation_name in OBSERVATION_NAMES:
		var field_note := world.get_node_or_null(observation_name) as BTVExplorationObservation
		_check(field_note != null, "EXPLORATION: %s exists" % observation_name)
		if field_note == null:
			continue
		_check(not field_note.observation_id.is_empty(), "EXPLORATION: %s has a stable ID" % observation_name)
		_check(not seen_ids.has(field_note.observation_id), "EXPLORATION: %s has a unique ID" % observation_name)
		seen_ids[field_note.observation_id] = true
		_check(field_note.get_node_or_null("Marker") is MeshInstance3D, "EXPLORATION: %s has a visible marker" % observation_name)
		player.call("_on_sensor_area_entered", field_note)
		player.call("_try_interact")
		_check(world.get_node("HUD/InteractionToast").text.contains(field_note.observation_title), "EXPLORATION: %s reaches the HUD" % observation_name)
		_check(world.get_node("HUD/InteractionToast").text.contains(field_note.observation_text), "EXPLORATION: %s presents its field-note text" % observation_name)
		_check(journal.get_observed_count() == seen_ids.size(), "EXPLORATION: %s is recorded exactly once" % observation_name)
		_check(world.get_node("HUD/Status").text.contains("Journal: %d/4" % seen_ids.size()), "EXPLORATION: journal HUD refreshes to %d/4" % seen_ids.size())
		_check(world.get_node("HUD/InteractionToast").text.contains("saved locally"), "EXPLORATION: %s reports local save success" % observation_name)
		player.call("_on_sensor_area_exited", field_note)

	_check(journal.get_observed_count() == 4, "EXPLORATION: all four field notes are recorded")
	_check(FileAccess.file_exists(journal_path), "EXPLORATION: field-note journal persists locally")

	var first_note := world.get_node("Clearing_FieldNote") as BTVExplorationObservation
	player.call("_on_sensor_area_entered", first_note)
	player.call("_try_interact")
	_check(journal.get_observed_count() == 4, "EXPLORATION: repeating a note does not inflate the unique count")
	_check(world.get_node("HUD/InteractionToast").text.contains("already recorded"), "EXPLORATION: repeated notes are identified as already recorded")

	await _test_real_sensor_overlap(player, world)
	await _test_playable_movement_and_jump(player)

	_clear_player_actions()
	root.remove_child(world)
	world.free()
	if FileAccess.file_exists(journal_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(journal_path))
	print("\\nEXPLORATION_PROTOTYPE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _test_real_sensor_overlap(player: BTVPlayerController, world: Node3D) -> void:
	var probe := BTVExplorationObservation.new()
	probe.name = "SensorOverlapAcceptanceProbe"
	probe.position = player.global_position + Vector3(0.0, 0.0, -1.2)
	probe.collision_layer = 2
	probe.collision_mask = 0
	probe.monitoring = true
	probe.observation_id = "sensor-overlap-acceptance-probe"
	probe.interaction_id = probe.observation_id
	probe.observation_title = "SENSOR TEST"
	probe.observation_text = "Real sensor overlap reached the interactable."
	var shape_node := CollisionShape3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = 1.2
	shape_node.shape = sphere
	probe.add_child(shape_node)
	world.add_child(probe)
	for _tick in range(4):
		await physics_frame
	var nearby: Array = player.get("_nearby_interactables")
	_check(nearby.has(probe), "EXPLORATION: physics sensor detects a real overlapping observation Area3D")
	var result: String = player.call("_try_interact")
	_check(result == probe.observation_text, "EXPLORATION: nearest interactable is selected through the real sensor path")
	probe.queue_free()
	for _tick in range(2):
		await physics_frame
	_check(not (player.get("_nearby_interactables") as Array).has(probe), "EXPLORATION: sensor removes an interactable after it leaves the scene")


func _test_playable_movement_and_jump(player: BTVPlayerController) -> void:
	for _tick in range(12):
		await physics_frame
	_check(player.is_on_floor(), "EXPLORATION: player settles onto the playable ground")
	var start_position := player.global_position
	Input.action_press(&"move_forward")
	for _tick in range(45):
		await physics_frame
	Input.action_release(&"move_forward")
	var travelled := start_position.distance_to(player.global_position)
	_check(travelled > 1.0, "EXPLORATION: held movement produces physical displacement in the scene")
	for _tick in range(35):
		await physics_frame
	_check(
		is_zero_approx(player.velocity.x) and is_zero_approx(player.velocity.z),
		"EXPLORATION: releasing movement brakes the player to rest",
	)
	_check(player.is_on_floor(), "EXPLORATION: player remains grounded after the route segment")

	Input.action_press(&"jump")
	await physics_frame
	Input.action_release(&"jump")
	_check(player.velocity.y > 0.0, "EXPLORATION: jump input produces upward velocity in the playable scene")
	for _tick in range(90):
		await physics_frame
	_check(player.is_on_floor(), "EXPLORATION: player lands back on the exploration ground")


func _clear_player_actions() -> void:
	for action_name in [&"move_forward", &"move_back", &"move_left", &"move_right", &"jump", &"dash", &"interact"]:
		Input.action_release(action_name)
	for action_name in [&"touch_move_forward", &"touch_move_back", &"touch_move_left", &"touch_move_right", &"touch_jump", &"touch_dash", &"touch_interact"]:
		Input.action_release(action_name)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
