extends SceneTree
## Acceptance checks for the first playable exploration greybox.

const ExplorationScene = preload("res://scenes/exploration_prototype.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
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
	var observation_count := 0
	for child in world.get_children():
		if child is BTVExplorationObservation:
			observation_count += 1
	_check(observation_count == 4, "EXPLORATION: four observation points are authored")
	var player := world.get_node("Player") as BTVPlayerController
	var field_note := world.get_node("Clearing_FieldNote") as BTVExplorationObservation
	player.call("_on_sensor_area_entered", field_note)
	player.call("_try_interact")
	_check(world.get_node("HUD/InteractionToast").text.contains("CLEARING"), "EXPLORATION: interaction result reaches the HUD")
	_check(world.get_node("HUD/InteractionToast").text.contains("safe navigation test space"), "EXPLORATION: field note content is presented")
	var journal := world.get("_journal") as BTVExplorationJournal
	_check(journal.get_observed_count() == 1, "EXPLORATION: new field note is recorded")
	_check(FileAccess.file_exists(journal_path), "EXPLORATION: field note journal persists locally")
	_check(world.get_node("HUD/Status").text.contains("Journal: 0/4"), "EXPLORATION: initial journal HUD is present")
	root.remove_child(world)
	world.free()
	print("\nEXPLORATION_PROTOTYPE_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
