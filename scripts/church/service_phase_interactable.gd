extends BTVInteractable
class_name BTVServicePhaseInteractable

var service_director: BTVServiceDirector


func interact(_actor: Node) -> String:
	if service_director == null:
		return "The service sequence is unavailable."
	return "Service moment: " + service_director.advance_phase()
