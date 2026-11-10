extends BTVInteractable
class_name BTVExplorationObservation

## Non-violent field observation point. No inventory, currency, mission or faith effects.

@export_multiline var observation_text := "A quiet place to observe the environment."


func interact(_actor: Node) -> String:
	return observation_text
