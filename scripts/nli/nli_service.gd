extends RefCounted
class_name NLIService

## Orchestrates parse -> validate -> request gate -> bounded knowledge/action handoff.
## This service never mutates authoritative mission, inventory or world state.

var _request_gate := NLIRequestGate.new()
var _knowledge_base: NLIKnowledgeBase


func _init(knowledge_base: NLIKnowledgeBase = null) -> void:
	_knowledge_base = knowledge_base if knowledge_base != null else NLIKnowledgeBase.new()


func handle_utterance(utterance: String, request_id: String, npc_id: StringName = &"", companion_id: String = "") -> Dictionary:
	var parsed := NLICommandParser.parse(utterance, request_id, companion_id)
	if not parsed.get("ok", false):
		return parsed

	var intent: Dictionary = parsed["intent"]
	var validation := NLIValidator.validate(intent)
	if not validation.get("ok", false):
		return validation

	# Cancellation targets an existing pending request; it must not first try
	# to register that same ID as a new request.
	if StringName(intent["kind"]) == &"cancel":
		var cancellation := _request_gate.cancel_request(String(intent["request_id"]))
		return {
			"ok": cancellation.get("ok", false),
			"intent": intent,
			"validation": validation,
			"result": cancellation
		}

	var started := _request_gate.begin_request(request_id)
	if not started.get("ok", false):
		return started

	var result: Dictionary
	match StringName(intent["kind"]):
		&"question":
			result = _knowledge_base.answer(npc_id, StringName(intent["topic"]))
		&"companion_command":
			result = {
				"accepted": true,
				"source": "validated_command_handoff",
				"command": String(intent["command"]),
				"companion_id": companion_id,
				"note": "No world state is changed by NLI. The companion gameplay system must explicitly accept and execute this command."
			}

	_request_gate.complete_request(request_id)
	return {
		"ok": true,
		"intent": intent,
		"validation": validation,
		"result": result
	}
