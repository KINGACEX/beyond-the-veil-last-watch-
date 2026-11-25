extends BTVInteractable
class_name BTVTestInteractable

## Neutral resident dialogue for the first playable prototype.
## This greeting does not create mission, faith, economy or inventory state.

func interact(_actor: Node) -> String:
	return "Resident: Good day, traveller. This is a prototype conversation."
