extends "res://scripts/interactable.gd"

var interaction_count := 0
var last_actor: Node

func interact(actor: Node) -> String:
	interaction_count += 1
	last_actor = actor
	return "fixture:" + interaction_id
