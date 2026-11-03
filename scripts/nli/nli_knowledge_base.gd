extends RefCounted
class_name NLIKnowledgeBase

## Authored, speaker-scoped knowledge only. Dialogue is never evidence.
## Profiles explicitly authorize the source records an NPC is allowed to know.

const PROVENANCE_CATEGORIES: Array[String] = ["Observed", "Reported", "Inferred", "Unconfirmed"]
const CANON_STATUSES: Array[String] = ["LOCKED", "SLICE", "RESERVED", "OPEN"]

var _profiles: Dictionary = {}
var _entries: Dictionary = {}
var _statement_ids: Dictionary = {}


## Registers one NPC knowledge profile and its permitted source identifiers.
## A source is not available to an NPC until it is explicitly allowlisted here.
func register_profile(npc_id: StringName, knowledge_scope: String, authorized_source_ids: Array) -> Dictionary:
	var clean_npc := String(npc_id).strip_edges()
	var clean_scope := knowledge_scope.strip_edges()
	if clean_npc.is_empty() or clean_scope.is_empty():
		return _failure("invalid_profile", "NPC identifier and knowledge scope are required.")
	if _profiles.has(StringName(clean_npc)):
		return _failure("profile_already_registered", "An NPC knowledge profile can only be registered once.")
	var sources: Dictionary = {}
	for source_value in authorized_source_ids:
		var source_id := String(source_value).strip_edges()
		if source_id.is_empty():
			return _failure("invalid_source_id", "Authorized source identifiers cannot be empty.")
		if sources.has(source_id):
			return _failure("duplicate_source_id", "Authorized source identifiers must be unique.")
		sources[source_id] = true
	_profiles[StringName(clean_npc)] = {
		"knowledge_scope": clean_scope,
		"authorized_sources": sources
	}
	return {"ok": true, "code": "profile_registered", "npc_id": clean_npc}


## Adds a complete provenance-bearing record. Invalid records are never stored.
func add_record(record: Dictionary) -> Dictionary:
	var required := ["npc_id", "topic_id", "statement_id", "response_text", "provenance_category", "source_id", "knowledge_scope", "canon_status", "is_evidence"]
	for field in required:
		if not record.has(field):
			return _failure("missing_field", "Knowledge record is missing: " + field)

	var npc_id := String(record["npc_id"]).strip_edges()
	var topic_id := String(record["topic_id"]).strip_edges()
	var statement_id := String(record["statement_id"]).strip_edges()
	var response_text := String(record["response_text"]).strip_edges()
	var source_id := String(record["source_id"]).strip_edges()
	var knowledge_scope := String(record["knowledge_scope"]).strip_edges()
	var provenance := String(record["provenance_category"])
	var canon_status := String(record["canon_status"])

	if npc_id.is_empty() or topic_id.is_empty() or statement_id.is_empty() or source_id.is_empty() or knowledge_scope.is_empty():
		return _failure("empty_identifier", "NPC, topic, statement, source and knowledge-scope identifiers are required.")
	if response_text.is_empty():
		return _failure("empty_response", "Knowledge response text cannot be empty.")
	if provenance not in PROVENANCE_CATEGORIES:
		return _failure("invalid_provenance", "The provenance category is not approved.")
	if canon_status not in CANON_STATUSES:
		return _failure("invalid_canon_status", "The canon status is not approved.")
	if bool(record["is_evidence"]):
		return _failure("dialogue_cannot_be_evidence", "NLI dialogue records must always set is_evidence to false.")
	if _statement_ids.has(statement_id):
		return _failure("duplicate_statement_id", "Statement identifiers must be unique within this knowledge dataset.")

	var npc_key := StringName(npc_id)
	if not _profiles.has(npc_key):
		return _failure("unknown_knowledge_profile", "The NPC has no registered knowledge profile.")
	var profile: Dictionary = _profiles[npc_key]
	if knowledge_scope != String(profile["knowledge_scope"]):
		return _failure("knowledge_scope_mismatch", "The record does not belong to this NPC's registered knowledge scope.")
	var authorized_sources: Dictionary = profile["authorized_sources"]
	if not authorized_sources.has(source_id):
		return _failure("source_outside_knowledge_scope", "The source is not authorized for this NPC's knowledge profile.")

	var stored := record.duplicate(true)
	stored["npc_id"] = npc_id
	stored["topic_id"] = topic_id
	stored["statement_id"] = statement_id
	stored["response_text"] = response_text
	stored["source_id"] = source_id
	stored["knowledge_scope"] = knowledge_scope
	var topic_key := StringName(topic_id)
	var npc_entries: Dictionary = _entries.get(npc_key, {})
	var topic_entries: Array = npc_entries.get(topic_key, [])
	topic_entries.append(stored)
	npc_entries[topic_key] = topic_entries
	_entries[npc_key] = npc_entries
	_statement_ids[statement_id] = true
	return {"ok": true, "code": "record_added", "statement_id": statement_id}


## Returns only this NPC's authorized knowledge. Conflicts remain unresolved.
func answer(npc_id: StringName, topic: StringName) -> Dictionary:
	if not _entries.has(npc_id):
		return _unknown()
	var npc_entries: Dictionary = _entries[npc_id]
	if not npc_entries.has(topic):
		return _unknown()
	var topic_entries: Array = npc_entries[topic]
	if topic_entries.size() != 1:
		return {
			"known": false,
			"ambiguous": true,
			"source": "knowledge_ambiguity",
			"statement_ids": _statement_ids_for(topic_entries),
			"response": "I have conflicting information and cannot give you a reliable answer.",
			"is_evidence": false
		}
	var entry: Dictionary = topic_entries[0]
	return {
		"known": true,
		"ambiguous": false,
		"source": "authored_npc_knowledge",
		"response": String(entry["response_text"]),
		"statement_id": String(entry["statement_id"]),
		"provenance_category": String(entry["provenance_category"]),
		"source_id": String(entry["source_id"]),
		"knowledge_scope": String(entry["knowledge_scope"]),
		"canon_status": String(entry["canon_status"]),
		"is_evidence": false
	}


func _statement_ids_for(entries: Array) -> Array[String]:
	var ids: Array[String] = []
	for entry in entries:
		ids.append(String(entry.get("statement_id", "")))
	return ids


func _unknown() -> Dictionary:
	return {
		"known": false,
		"ambiguous": false,
		"source": "knowledge_boundary",
		"response": "I don't know enough to answer that.",
		"is_evidence": false
	}


func _failure(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
