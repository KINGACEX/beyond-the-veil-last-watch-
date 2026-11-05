extends "res://scripts/interactable.gd"

@export var interaction_id: String = ""
@export var enabled_for_test: bool = true
var interaction_count := 0
var last_actor: Node

func interact(actor: Node) -> String:
	interaction_count += 1
	last_actor = actor
	return "fixture:" + interaction_id
