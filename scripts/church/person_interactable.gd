extends BTVInteractable
class_name BTVChapelPersonInteractable

## Lightweight, non-transactional conversation for chapel greybox NPCs.
## No currency, inventory, mission, faith or progression effects are attached.

@export var character_name: String = "Community Member"
@export_multiline var greeting: String = "Welcome. Please feel free to join the service."
@export_multiline var follow_up: String = "I hope you find a place to settle in and fellowship."

var _has_greeted := false


func interact(_actor: Node) -> String:
	var response := greeting if not _has_greeted else follow_up
	_has_greeted = true
	return character_name + ": " + response
