extends Area3D
class_name BTVInteractable

## Base contract for objects that can be interacted with by the player.
## Place on an Area3D with a CollisionShape3D and configure its collision layer.

@export var interaction_prompt: String = "Interact"

## Override in concrete interactables. Return a short result for the caller to present.
func interact(_actor: Node) -> String:
	return interaction_prompt
