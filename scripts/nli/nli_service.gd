extends RefCounted
class_name NLIService

## Orchestrates parse -> validate -> request gate -> bounded knowledge/action handoff.
## This service never mutates authoritative mission, inventory or world state.

var _request_gate := NLIRequestGate.new()
var _knowledge_base: NLIKnowledgeBase
# The adapter remains the authority for companion execution state. The service
# retains the request-ID reservation and reconciles terminal adapter outcomes.
var _companion_adapters: Dictionary = {}


func _init(knowledge_base: NLIKnowledgeBase = null) -> void:
	_knowledge_base = knowledge_base if knowledge_base != null else NLIKnowledgeBase.new()


func handle_utterance(utterance: String, request_id: String, npc_id: StringName = &"", companion_id: String = "") -> Dictionary:
	# Canonicalize identity once at the service boundary. Every downstream
	# component and returned envelope uses this exact identifier.
	var canonical_request_id := request_id.strip_edges()
	if canonical_request_id.is_empty():
		return {
			"ok": false,
			"code": "missing_request_id",
			"message": "A request identifier is required."
		}

	var parsed := NLICommandParser.parse(utterance, canonical_request_id, companion_id)
	if not parsed.get("ok", false):
		return parsed

	var intent: Dictionary = parsed["intent"]
	var validation := NLIValidator.validate(intent)
	if not validation.get("ok", false):
		return validation

	# Cancellation targets an existing pending request; it must not first try
	# to register that same ID as a new request.
	if StringName(intent["kind"]) == &"cancel":
		var cancellation: Dictionary
		if _companion_adapters.has(canonical_request_id):
			var adapter = _companion_adapters[canonical_request_id]
			cancellation = adapter.cancel_request(canonical_request_id, Time.get_ticks_msec())
			if cancellation.get("ok", false):
				_request_gate.cancel_request(canonical_request_id)
				_companion_adapters.erase(canonical_request_id)
		else:
			cancellation = _request_gate.cancel_request(canonical_request_id)
		return {
			"ok": cancellation.get("ok", false),
			"intent": intent,
			"validation": validation,
			"result": cancellation
		}

	var started := _request_gate.begin_request(canonical_request_id)
	if not started.get("ok", false):
		return started

	var result: Dictionary
	match StringName(intent["kind"]):
		&"question":
			result = _knowledge_base.answer(npc_id, StringName(intent["topic"]))
		&"companion_command":
			result = {
				"stage": "validated",
				"source": "validated_command_request",
				"request_id": canonical_request_id,
				"intent_kind": "companion_command",
				"target_owner_id": companion_id,
				"command": String(intent["command"]),
				"note": "Validation succeeded. The companion adapter has not yet dispatched this request to the actor."
			}
			return {
				"ok": true,
				"intent": intent,
				"validation": validation,
				"result": result
			}

	_request_gate.complete_request(canonical_request_id)
	return {
		"ok": true,
		"intent": intent,
		"validation": validation,
		"result": result
	}


## Dispatches a previously validated companion handoff and reconciles its
## terminal adapter state back into the service's request-ID reservation.
func dispatch_companion_handoff(handoff: Dictionary, adapter: Object, actor: Object, scene_generation: int, now_msec: int, timeout_msec: int) -> Dictionary:
	var request_id := String(handoff.get("request_id", "")).strip_edges()
	if request_id.is_empty():
		return _failure("missing_request_id", "A companion handoff requires a request identifier.")
	if not _request_gate.is_pending(request_id):
		return _failure("request_not_pending", "The service has no pending reservation for this handoff.")
	if not is_instance_valid(adapter) or not adapter.has_method("dispatch") or not adapter.has_method("get_state"):
		return _failure("adapter_contract_missing", "A compatible companion adapter is required.")
	if _companion_adapters.has(request_id):
		return _failure("duplicate_dispatch", "This request has already been dispatched to an adapter.")

	var dispatched: Dictionary = adapter.call("dispatch", handoff, actor, scene_generation, now_msec, timeout_msec)
	if not dispatched.get("ok", false):
		_request_gate.cancel_request(request_id)
		return dispatched

	_companion_adapters[request_id] = adapter
	_reconcile_companion_request(request_id)
	return dispatched


## Reads adapter-owned state and synchronizes the service reservation only when
## the adapter reaches a terminal state. The adapter remains execution authority.
func get_companion_request_state(request_id: String) -> String:
	var clean_id := request_id.strip_edges()
	if not _companion_adapters.has(clean_id):
		return "unknown"
	_reconcile_companion_request(clean_id)
	var adapter = _companion_adapters.get(clean_id)
	if adapter == null or not is_instance_valid(adapter):
		return "adapter_unavailable"
	return String(adapter.call("get_state", clean_id))


func _reconcile_companion_request(request_id: String) -> void:
	if not _companion_adapters.has(request_id):
		return
	var adapter = _companion_adapters[request_id]
	if adapter == null or not is_instance_valid(adapter):
		return
	var state := String(adapter.call("get_state", request_id))
	match state:
		"executed", "failed", "rejected_by_actor", "expired":
			_request_gate.complete_request(request_id)
			_companion_adapters.erase(request_id)
		"cancelled":
			_request_gate.cancel_request(request_id)
			_companion_adapters.erase(request_id)


static func _failure(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
