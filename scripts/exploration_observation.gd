extends BTVInteractable
class_name BTVExplorationObservation

## Non-violent field observation point. No inventory, currency, mission or faith effects.

signal observation_recorded(observation_id: String, title: String)

@export var observation_id: String = ""
@export var observation_title: String = "Field Note"
@export_multiline var observation_text := "A quiet place to observe the environment."


func interact(_actor: Node) -> String:
	if not observation_id.strip_edges().is_empty():
		observation_recorded.emit(observation_id.strip_edges(), observation_title)
	return observation_text
