extends Node
class_name BTVServiceDirector

## Slice-scoped, deterministic Sunday service state. No timer, score, reward or forced progression.

signal phase_changed(phase_id: String, phase_label: String)
signal service_completed

const SERVICE_PHASES: Array[Dictionary] = [
	{"id": "arrival_fellowship", "label": "Arrival and Fellowship"},
	{"id": "welcome", "label": "Welcome"},
	{"id": "praise_worship", "label": "Praise and Worship"},
	{"id": "prayer", "label": "Prayer"},
	{"id": "scripture_reading", "label": "Scripture Reading"},
	{"id": "kitfit", "label": "KITFIT"},
	{"id": "offering", "label": "Offering"},
	{"id": "sermon", "label": "Sermon"},
	{"id": "response_reflection", "label": "Response and Reflection"},
	{"id": "communion", "label": "Communion"},
	{"id": "announcements", "label": "Announcements"},
	{"id": "closing_prayer", "label": "Closing Prayer"},
	{"id": "fellowship_service", "label": "Fellowship and Service"},
]

var _phase_index: int = 0
var _service_complete: bool = false
var _communion_context_active: bool = false
var _visitor_listened: bool = false
var _covenant_alert_pending: bool = false


func get_phase_id() -> String:
	return str(SERVICE_PHASES[_phase_index]["id"])


func get_phase_label() -> String:
	return str(SERVICE_PHASES[_phase_index]["label"])


func get_phase_index() -> int:
	return _phase_index


func get_phase_count() -> int:
	return SERVICE_PHASES.size()


func is_service_complete() -> bool:
	return _service_complete


func advance_phase() -> String:
	if _service_complete:
		return "The service sequence is complete. You may remain and fellowship."
	if _phase_index < SERVICE_PHASES.size() - 1:
		_phase_index += 1
		phase_changed.emit(get_phase_id(), get_phase_label())
	if _phase_index == SERVICE_PHASES.size() - 1 and not _service_complete:
		_service_complete = true
		service_completed.emit()
	return get_phase_label()


func set_communion_context_active(active: bool) -> void:
	_communion_context_active = active


func is_communion_context_active() -> bool:
	return _communion_context_active


func record_visitor_listened() -> void:
	_visitor_listened = true


func did_listen_to_visitor() -> bool:
	return _visitor_listened


func queue_covenant_alert() -> void:
	_covenant_alert_pending = true


func is_covenant_alert_pending() -> bool:
	return _covenant_alert_pending


## The alert can only be surfaced after the service and outside CommunionContextZone.
func take_deliverable_covenant_alert() -> bool:
	if not _covenant_alert_pending or not _service_complete or _communion_context_active:
		return false
	_covenant_alert_pending = false
	return true
