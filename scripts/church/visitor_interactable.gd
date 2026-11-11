extends BTVInteractable
class_name BTVVisitorInteractable

var service_director: BTVServiceDirector


func interact(_actor: Node) -> String:
	if service_director != null:
		service_director.record_visitor_listened()
	return "A visitor mentions a relative who went to work remotely in a rural area and has missed several check-ins. No location is named."
