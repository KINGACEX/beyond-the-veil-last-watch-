extends RefCounted
class_name BTVExplorationJournal

## Local, non-monetized record of environmental observations discovered by the player.

var _save_path: String
var _observed: Dictionary = {}


func _init(save_path: String = "user://btv_exploration_journal.cfg") -> void:
	_save_path = save_path
	load_from_disk()


func load_from_disk() -> bool:
	_observed.clear()
	var config := ConfigFile.new()
	var error := config.load(_save_path)
	if error == ERR_FILE_NOT_FOUND:
		return true
	if error != OK:
		return false
	var saved_ids: Variant = config.get_value("journal", "observed_ids", [])
	if not (saved_ids is Array):
		return false
	for saved_id in saved_ids:
		if saved_id is String and not saved_id.strip_edges().is_empty():
			_observed[saved_id.strip_edges()] = true
	return true


func record_observation(observation_id: String) -> bool:
	var normalized_id := observation_id.strip_edges()
	if normalized_id.is_empty() or _observed.has(normalized_id):
		return false
	_observed[normalized_id] = true
	return true


func has_observation(observation_id: String) -> bool:
	return _observed.has(observation_id.strip_edges())


func get_observed_count() -> int:
	return _observed.size()


func get_observed_ids() -> Array[String]:
	var ids: Array[String] = []
	for observation_id in _observed.keys():
		ids.append(str(observation_id))
	ids.sort()
	return ids


func save_to_disk() -> bool:
	var config := ConfigFile.new()
	config.set_value("journal", "observed_ids", get_observed_ids())
	return config.save(_save_path) == OK
