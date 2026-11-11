extends RefCounted
class_name NLICommandParser

## Conservative phrase parser. It recognises explicit supported forms only.
## Free-form language-model interpretation is intentionally outside this module.

const COMMAND_PHRASES := {
	"follow me": &"regroup",
	"come with me": &"regroup",
	"stay here": &"hold",
	"hold position": &"hold",
	"scout ahead": &"scout",
	"look ahead": &"scout",
	"track the trail": &"track",
	"track them": &"track",
	"retrieve it": &"retrieve",
	"bring it back": &"retrieve",
	"protect me": &"protect",
	"attack": &"attack"
}

const QUESTION_PREFIXES: Array[String] = ["who ", "what ", "where ", "when ", "why ", "how ", "tell me about "]

## Complete normalized question forms only. No suffix/last-word guessing.
const QUESTION_ALIASES := {
	"what is your name": &"name",
	"what's your name": &"name",
	"who are you": &"name",
	"tell me about your name": &"name",
	"where are we": &"location",
	"what is our location": &"location",
	"where is our location": &"location",
	"where is ridgeview": &"ridgeview_outpost",
	"where is ridgeview outpost": &"ridgeview_outpost",
	"where is the ridgeview outpost": &"ridgeview_outpost",
	"where is the outpost": &"ridgeview_outpost",
	"tell me about ridgeview": &"ridgeview_outpost",
	"tell me about ridgeview outpost": &"ridgeview_outpost"
}


static func parse(utterance: String, request_id: String, companion_id: String = "") -> Dictionary:
	var clean := utterance.strip_edges().to_lower()
	if clean.is_empty():
		return _unparsed("empty_input", "No text was provided.")

	if clean in ["cancel", "never mind", "stop that"]:
		return {
			"ok": true,
			"intent": {
				"kind": &"cancel",
				"request_id": request_id,
				"utterance": clean
			}
		}

	if COMMAND_PHRASES.has(clean):
		return {
			"ok": true,
			"intent": {
				"kind": &"companion_command",
				"command": COMMAND_PHRASES[clean],
				"companion_id": companion_id,
				"request_id": request_id,
				"utterance": clean
			}
		}

	if _looks_like_question(clean):
		var topic := _extract_topic(clean)
		if topic == &"":
			return _unparsed("clarification_required", "That question does not match an explicitly supported topic. Please rephrase it using a supported question form.")
		return {
			"ok": true,
			"intent": {
				"kind": &"question",
				"topic": topic,
				"request_id": request_id,
				"utterance": clean
			}
		}

	return _unparsed("unrecognised_phrase", "The phrase is not covered by the current deterministic grammar.")


static func _looks_like_question(clean: String) -> bool:
	if clean.ends_with("?"):
		return true
	for prefix in QUESTION_PREFIXES:
		if clean.begins_with(prefix):
			return true
	return false


static func _extract_topic(clean: String) -> StringName:
	var question := clean.trim_suffix("?").strip_edges()
	if QUESTION_ALIASES.has(question):
		return QUESTION_ALIASES[question]
	return &""


static func _unparsed(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
