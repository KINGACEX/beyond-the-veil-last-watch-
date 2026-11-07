extends RefCounted

## Test double only. This is not a production Ember actor.
var actor_id := "ember"
var mode := "accept_complete"
var saved_decision: Callable
var saved_completion: Callable


func get_nli_actor_id() -> String:
	return actor_id


func receive_nli_command(_envelope: Dictionary, decision_callback: Callable, completion_callback: Callable) -> void:
	saved_decision = decision_callback
	saved_completion = completion_callback
	match mode:
		"accept_complete":
			decision_callback.call(true, "")
			completion_callback.call(true, "")
		"reject":
			decision_callback.call(false, "Actor declined the request.")
		"fail":
			decision_callback.call(true, "")
			completion_callback.call(false, "Actor execution failed.")
		"duplicate":
			decision_callback.call(true, "")
			decision_callback.call(true, "Duplicate acknowledgement.")
			completion_callback.call(true, "")
		"delayed":
			pass


func accept_saved() -> void:
	if saved_decision.is_valid():
		saved_decision.call(true, "")


func complete_saved() -> void:
	if saved_completion.is_valid():
		saved_completion.call(true, "")
