extends RefCounted
class_name NLIValidator

const SUPPORTED_COMPANION_COMMANDS: Array[StringName] = [
	&"protect", &"scout", &"track", &"retrieve", &"hold", &"regroup"
]
const RECOGNISED_BUT_DEFERRED_COMMANDS: Array[StringName] = [&"attack"]


## Validates a parsed intent without executing it or mutating game state.
static func validate(intent: Dictionary) -> Dictionary:
	if not intent.has("kind"):
		return _failure("missing_kind", "The request has no recognised intent type.")

	var kind: StringName = StringName(intent.get("kind", ""))
	match kind:
		&"question":
			var topic: StringName = StringName(intent.get("topic", ""))
			if topic == &"":
				return _failure("missing_topic", "The question needs a recognised topic.")
			return {"ok": true, "code": "valid_question", "message": "Question is ready for an NPC knowledge check."}
		&"companion_command":
			var command: StringName = StringName(intent.get("command", ""))
			if command in RECOGNISED_BUT_DEFERRED_COMMANDS:
				return _failure("feature_deferred", "That command is recognised but unavailable until its gameplay system is approved and implemented.")
			if command not in SUPPORTED_COMPANION_COMMANDS:
				return _failure("unknown_command", "That companion command is not in the approved command vocabulary.")
			if String(intent.get("companion_id", "")).strip_edges().is_empty():
				return _failure("missing_companion", "A valid companion target is required.")
			return {"ok": true, "code": "valid_command", "message": "Command is validated and ready for the companion system."}
		&"cancel":
			if String(intent.get("request_id", "")).strip_edges().is_empty():
				return _failure("missing_request_id", "Cancellation requires the request identifier.")
			return {"ok": true, "code": "valid_cancel", "message": "Cancellation request is valid."}
		_:
			return _failure("unknown_intent", "The request could not be classified safely.")


static func _failure(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
