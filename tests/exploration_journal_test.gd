extends SceneTree
## Persistence and validation tests for the local exploration journal.

const Journal = preload("res://scripts/exploration_journal.gd")
const TEST_PATH := "user://btv_exploration_journal_test.cfg"


func _initialize() -> void:
	var absolute_path := ProjectSettings.globalize_path(TEST_PATH)
	if FileAccess.file_exists(TEST_PATH):
		DirAccess.remove_absolute(absolute_path)
	var journal = Journal.new(TEST_PATH)
	_check(journal.get_observed_count() == 0, "JOURNAL: starts empty without a save")
	_check(not journal.record_observation("   "), "JOURNAL: rejects blank observation IDs")
	_check(journal.record_observation("pond-note"), "JOURNAL: accepts a new observation")
	_check(not journal.record_observation("pond-note"), "JOURNAL: duplicate observation is not counted twice")
	_check(journal.record_observation(" ridge-note "), "JOURNAL: trims whitespace from observation IDs")
	_check(journal.get_observed_count() == 2, "JOURNAL: counts unique observations")
	_check(journal.has_observation("ridge-note"), "JOURNAL: lookup uses normalized IDs")
	_check(journal.save_to_disk(), "JOURNAL: saves to local user data")
	var reloaded = Journal.new(TEST_PATH)
	_check(reloaded.get_observed_count() == 2, "JOURNAL: reload restores saved observations")
	_check(reloaded.get_observed_ids() == ["pond-note", "ridge-note"], "JOURNAL: IDs are returned in stable sorted order")
	if FileAccess.file_exists(TEST_PATH):
		DirAccess.remove_absolute(absolute_path)
	print("\nEXPLORATION_JOURNAL_TESTS: PASS")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
