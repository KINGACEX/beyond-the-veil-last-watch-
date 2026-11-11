extends RefCounted
class_name NLIRequestGate

## In-memory request lifecycle guard. Persistence is deliberately handled elsewhere.
## Request identifiers are single-use across pending, completed and cancelled states.
var _pending: Dictionary = {}
var _completed: Dictionary = {}
var _cancelled: Dictionary = {}


func begin_request(request_id: String) -> Dictionary:
	var clean_id := request_id.strip_edges()
	if clean_id.is_empty():
		return _failure("missing_request_id", "A request identifier is required.")
	if _pending.has(clean_id) or _completed.has(clean_id) or _cancelled.has(clean_id):
		return _failure("duplicate_request", "This request identifier has already been used.")
	_pending[clean_id] = true
	return {"ok": true, "code": "request_started", "request_id": clean_id}


func complete_request(request_id: String) -> Dictionary:
	var clean_id := request_id.strip_edges()
	if not _pending.has(clean_id):
		return _failure("request_not_pending", "Only a pending request can be completed.")
	_pending.erase(clean_id)
	_completed[clean_id] = true
	return {"ok": true, "code": "request_completed", "request_id": clean_id}


func cancel_request(request_id: String) -> Dictionary:
	var clean_id := request_id.strip_edges()
	if not _pending.has(clean_id):
		return _failure("request_not_pending", "The request is not pending or has already finished.")
	_pending.erase(clean_id)
	_cancelled[clean_id] = true
	return {"ok": true, "code": "request_cancelled", "request_id": clean_id}


func is_pending(request_id: String) -> bool:
	return _pending.has(request_id.strip_edges())


func is_completed(request_id: String) -> bool:
	return _completed.has(request_id.strip_edges())


func is_cancelled(request_id: String) -> bool:
	return _cancelled.has(request_id.strip_edges())


static func _failure(code: String, message: String) -> Dictionary:
	return {"ok": false, "code": code, "message": message}
