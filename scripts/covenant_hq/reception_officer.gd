extends BTVInteractable
class_name BTVHQReceptionOfficer

## Unnamed, session-local reception NPC placeholder for the HQ vertical-slice blockout.
## Dialogue is limited to navigation; this actor has no mission or case knowledge.

var _has_greeted_player := false


func interact(actor: Node) -> String:
	if not actor is BTVPlayerController:
		return "The reception officer is waiting to assist a visitor."

	var look_target := actor.global_position
	look_target.y = global_position.y
	if global_position.distance_squared_to(look_target) > 0.01:
		look_at(look_target, Vector3.UP)

	if not _has_greeted_player:
		_has_greeted_player = true
		return "Welcome to the headquarters. The operations room is to your left; the training court is to your right."

	return "Need directions? Follow the left-hand corridor to operations, or use the right-hand corridor for the training court."
