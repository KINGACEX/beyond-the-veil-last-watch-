extends RefCounted
class_name NLICompanionAdapter

## Dispatch boundary between validated NLI envelopes and an actor-owned receiver.
## The actor makes the acceptance decision and reports execution completion.
## This adapter never decides whether a gameplay command is appropriate.

const Lifecycle = preload("res://scripts/nli/nli_request_lifecycle.gd")

var _lifecycle = Lifecycle.new()


func dispatch(validated_handoff: Dictionary, actor: Object, scene_generation: int, now_msec: int, timeout_msec: int) -> Dictionary:
	var request_id := String(validated_handoff.get("request_id", "")).strip_edges()
	var owner_id := String(validated_handoff.get("target_owner_id", "")).strip_edges()
	var command := String(validated_handoff.get("command", "")).strip_edges()

	if String(validated_handoff.get("stage", "")) != "validated":
		return _failure("handoff_not_validated", "Only a validated NLI handoff may be dispatched.")
	if request_id.is_empty() or owner_id.is_empty() or command.is_empty():
		return _failure("incomplete_handoff", "The handoff must include request ID, target owner and command.")
	if not is_instance_valid(actor):
		return _failure("actor_unavailable", "The target actor is not available.")
	if not actor.has_method("get_nli_actor_id") or not actor.has_method("receive_nli_command"):
		return _failure("actor_contract_missing", "The target does not implement the NLI companion actor contract.")

	var actual_owner_id := String(actor.call("get_nli_actor_id")).strip_edges()
	if actual_owner_id != owner_id:
		return _failure("actor_mismatch", "The supplied actor does not match the intended handoff owner.")

	var started: Dictionary = _lifecycle.begin_request(request_id, owner_id, scene_generation, now_msec, timeout_msec)
	if not started.get("ok", false):
		return started

	var decision_callback := func(accepted: bool, reason: String = "") -> void:
		_on_actor_decision(request_id, owner_id, scene_generation, accepted, reason)

	var completion_callback := func(succeeded: bool, reason: String = "") -> void:
		_on_actor_completion(request_id, succeeded, reason)

	var actor_envelope := {
		"request_id": request_id,
		"actor_id": owner_id,
		"scene_generation": scene_generation,
		"command": command
	}
	actor.call("receive_nli_command", actor_envelope, decision_callback, completion_callback)

	return {
		"ok": true,
		"code": "handoff_dispatched",
		"request_id": request_id,
		"actor_id": owner_id,
		"state": _lifecycle.get_state(request_id),
		"note": "The actor now owns the acceptance and execution decision."
	}


func expire_due(now_msec: int) -> Array[String]:
	return _lifecycle.expire_due(now_msec)


func get_state(request_id: String) -> String:
	return _lifecycle.get_state(request_id)


func _on_actor_decision(request_id: String, actor_id: String, scene_generation: int, accepted: bool, reason: String) -> void:
	if accepted:
		var accepted_result: Dictionary = _lifecycle.actor_accept(request_id, actor_id, scene_generation, Time.get_ticks_msec())
		if accepted_result.get("ok", false):
			_lifecycle.mark_executing(request_id)
	else:
		_lifecycle.actor_reject(request_id, actor_id, scene_generation, reason, Time.get_ticks_msec())


func _on_actor_completion(request_id: String, succeeded: bool, reason: String) -> void:
	if succeeded:
		_lifecycle.complete_request(request_id)
	else:
		_lifecycle.fail_request(request_id, reason)


static func _failure(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
