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

## Explicit aliases only. Add a topic only when the relevant canon/data contract exists.
const TOPIC_ALIASES := {
	"name": &"name",
	"your name": &"name",
	"who are you": &"name",
	"ridgeview": &"ridgeview_outpost",
	"ridgeview outpost": &"ridgeview_outpost",
	"the ridgeview outpost": &"ridgeview_outpost",
	"outpost": &"ridgeview_outpost",
	"the outpost": &"ridgeview_outpost",
	"location": &"location",
	"our location": &"location",
	"where are we": &"location"
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

	for prefix in QUESTION_PREFIXES:
		if clean.begins_with(prefix):
			return {
				"ok": true,
				"intent": {
					"kind": &"question",
					"topic": _extract_topic(clean),
					"request_id": request_id,
					"utterance": clean
				}
			}

	return _unparsed("unrecognised_phrase", "The phrase is not covered by the current deterministic grammar.")


static func _extract_topic(clean: String) -> StringName:
	var question := clean.trim_suffix("?").strip_edges()
	for alias in TOPIC_ALIASES:
		if question.ends_with(String(alias)) or question == String(alias):
			return TOPIC_ALIASES[alias]
	return &""


static func _unparsed(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
