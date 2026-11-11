extends BTVInteractable
class_name BTVTestInteractable

## Neutral prototype target. This deliberately has no mission, faith, economy or inventory effects.

func interact(_actor: Node) -> String:
	return "Interaction test successful. The reusable interaction contract is responding."
