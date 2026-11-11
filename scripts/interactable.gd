extends Area3D
class_name BTVInteractable

## Base contract for objects that can be interacted with by the player.

@export var interaction_id: String = ""
@export var interaction_prompt: String = "Interact"
@export var interaction_enabled: bool = true


func can_interact(_actor: Node) -> bool:
	return interaction_enabled and is_inside_tree()


## Override in concrete interactables. Return a short result for the caller to present.
func interact(_actor: Node) -> String:
	return interaction_prompt
