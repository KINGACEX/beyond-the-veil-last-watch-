extends RefCounted
class_name NLIRequestLifecycle

## In-memory owner for asynchronous companion handoffs.
## The caller supplies a monotonic clock and scene generation; this class does
## not dispatch actor commands or mutate game-world state.

var _requests: Dictionary = {}


func begin_request(request_id: String, owner_id: String, scene_generation: int, now_msec: int, timeout_msec: int) -> Dictionary:
	var clean_id := request_id.strip_edges()
	var clean_owner := owner_id.strip_edges()
	if clean_id.is_empty():
		return _failure("missing_request_id", "A request identifier is required.")
	if clean_owner.is_empty():
		return _failure("missing_owner_id", "An actor owner identifier is required.")
	if scene_generation < 0 or now_msec < 0 or timeout_msec <= 0:
		return _failure("invalid_lifecycle_parameters", "Generation and clock values must be non-negative; timeout must be positive.")
	if _requests.has(clean_id):
		return _failure("duplicate_request", "This request identifier has already been used.")

	_requests[clean_id] = {
		"request_id": clean_id,
		"owner_id": clean_owner,
		"scene_generation": scene_generation,
		"state": "pending",
		"created_at_msec": now_msec,
		"deadline_msec": now_msec + timeout_msec,
		"rejection_reason": ""
	}
	return _success("request_started", clean_id, "pending")


func actor_accept(request_id: String, actor_id: String, scene_generation: int, now_msec: int) -> Dictionary:
	var checked := _validate_actor_callback(request_id, actor_id, scene_generation, now_msec)
	if not checked.get("ok", false):
		return checked
	var record: Dictionary = checked["record"]
	record["state"] = "accepted"
	return _success("actor_accepted", String(record["request_id"]), "accepted")


func actor_reject(request_id: String, actor_id: String, scene_generation: int, reason: String, now_msec: int) -> Dictionary:
	var checked := _validate_actor_callback(request_id, actor_id, scene_generation, now_msec)
	if not checked.get("ok", false):
		return checked
	var record: Dictionary = checked["record"]
	record["state"] = "rejected_by_actor"
	record["rejection_reason"] = reason.strip_edges()
	return _success("actor_rejected", String(record["request_id"]), "rejected_by_actor", {
		"reason": String(record["rejection_reason"])
	})


func mark_executing(request_id: String) -> Dictionary:
	var clean_id := request_id.strip_edges()
	if not _requests.has(clean_id):
		return _failure("request_not_found", "The request does not exist.")
	var record: Dictionary = _requests[clean_id]
	if String(record["state"]) != "accepted":
		return _failure("request_not_accepted", "Only an actor-accepted request can begin execution.")
	record["state"] = "executing"
	return _success("execution_started", clean_id, "executing")


func complete_request(request_id: String) -> Dictionary:
	var clean_id := request_id.strip_edges()
	if not _requests.has(clean_id):
		return _failure("request_not_found", "The request does not exist.")
	var record: Dictionary = _requests[clean_id]
	if String(record["state"]) != "executing":
		return _failure("request_not_executing", "Only an executing request can complete.")
	record["state"] = "executed"
	return _success("request_executed", clean_id, "executed")


func cancel_request(request_id: String, now_msec: int) -> Dictionary:
	var clean_id := request_id.strip_edges()
	if not _requests.has(clean_id):
		return _failure("request_not_found", "The request does not exist.")
	var record: Dictionary = _requests[clean_id]
	var state := String(record["state"])
	if state == "executing":
		return _failure("execution_already_started", "Cancellation after execution starts requires an explicit actor interrupt contract.")
	if state != "pending" and state != "accepted":
		return _failure("request_not_pending", "Only a pending or accepted request can be cancelled.")
	if now_msec >= int(record["deadline_msec"]):
		record["state"] = "expired"
		return _failure("request_expired", "The request deadline has passed.")
	record["state"] = "cancelled"
	return _success("request_cancelled", clean_id, "cancelled")


func expire_due(now_msec: int) -> Array[String]:
	var expired: Array[String] = []
	for request_id in _requests:
		var record: Dictionary = _requests[request_id]
		var state := String(record["state"])
		if (state == "pending" or state == "accepted") and now_msec >= int(record["deadline_msec"]):
			record["state"] = "expired"
			expired.append(String(request_id))
	return expired


func get_state(request_id: String) -> String:
	var clean_id := request_id.strip_edges()
	if not _requests.has(clean_id):
		return "unknown"
	return String(_requests[clean_id]["state"])


func _validate_actor_callback(request_id: String, actor_id: String, scene_generation: int, now_msec: int) -> Dictionary:
	var clean_id := request_id.strip_edges()
	var clean_actor := actor_id.strip_edges()
	if clean_id.is_empty():
		return _failure("missing_request_id", "A request identifier is required.")
	if not _requests.has(clean_id):
		return _failure("request_not_found", "The request does not exist.")
	var record: Dictionary = _requests[clean_id]
	if String(record["state"]) != "pending":
		return _failure("request_not_pending", "Only a pending request can receive an actor acknowledgement.")
	if scene_generation != int(record["scene_generation"]):
		return _failure("stale_scene_callback", "The callback belongs to a different scene generation.")
	if clean_actor != String(record["owner_id"]):
		return _failure("actor_mismatch", "The callback actor does not own this request.")
	if now_msec >= int(record["deadline_msec"]):
		record["state"] = "expired"
		return _failure("request_expired", "The actor acknowledgement arrived after the request deadline.")
	return {"ok": true, "record": record}


static func _success(code: String, request_id: String, state: String, extra: Dictionary = {}) -> Dictionary:
	var result := {
		"ok": true,
		"code": code,
		"request_id": request_id,
		"state": state
	}
	for key in extra:
		result[key] = extra[key]
	return result


static func _failure(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
