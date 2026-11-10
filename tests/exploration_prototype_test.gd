extends SceneTree
## Acceptance checks for the first playable exploration greybox and its complete field-note loop.

const ExplorationScene = preload("res://scenes/exploration_prototype.tscn")
const OBSERVATION_NAMES := [
	"Clearing_FieldNote",
	"Pond_FieldNote",
	"Ridge_FieldNote",
	"Forest_FieldNote",
]


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

	_check(journal.get_observed_count() == 4, "EXPLORATION: all four field notes are recorded")
	_check(FileAccess.file_exists(journal_path), "EXPLORATION: field-note journal persists locally")

	var first_note := world.get_node("Clearing_FieldNote") as BTVExplorationObservation
	player.call("_on_sensor_area_entered", first_note)
	player.call("_try_interact")
	_check(journal.get_observed_count() == 4, "EXPLORATION: repeating a note does not inflate the unique count")
	_check(world.get_node("HUD/InteractionToast").text.contains("already recorded"), "EXPLORATION: repeated notes are identified as already recorded")

	root.remove_child(world)
	world.free()
	if FileAccess.file_exists(journal_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(journal_path))
	print("\\nEXPLORATION_PROTOTYPE_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
