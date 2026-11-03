extends RefCounted
class_name NLIKnowledgeBase

## Authored facts only. No generated answer may be treated as canon or evidence.
## Entries are keyed by an explicit topic and may be scoped to an NPC identifier.

var _entries: Dictionary = {}


func add_entry(npc_id: StringName, topic: StringName, response: String) -> void:
	var clean_response := response.strip_edges()
	if npc_id == &"" or topic == &"" or clean_response.is_empty():
		return
	var npc_entries: Dictionary = _entries.get(npc_id, {})
	npc_entries[topic] = clean_response
	_entries[npc_id] = npc_entries


func answer(npc_id: StringName, topic: StringName) -> Dictionary:
	if not _entries.has(npc_id):
		return _unknown()
	var npc_entries: Dictionary = _entries[npc_id]
	if not npc_entries.has(topic):
		return _unknown()
	return {
		"known": true,
		"source": "authored_npc_knowledge",
		"response": String(npc_entries[topic])
	}


func _unknown() -> Dictionary:
	return {
		"known": false,
		"source": "knowledge_boundary",
		"response": "I don't know enough to answer that."
	}
