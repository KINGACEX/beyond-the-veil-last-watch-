extends SceneTree

const MAIN_SCENE := "res://scenes/main.tscn"

func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load(MAIN_SCENE) as PackedScene
	if packed == null:
		push_error("FAIL: main scene did not load for interaction HUD test.")
		quit(1)
		return

	var main_root := packed.instantiate()
	get_root().add_child(main_root)
	var player := main_root.get_node_or_null("Player") as BTVPlayerController
	var interactable := main_root.get_node_or_null("TestInteractable") as BTVInteractable
	var hud := main_root.get_node_or_null("InteractionHUD") as BTVInteractionHUD
	if player == null or interactable == null or hud == null:
		push_error("FAIL: main scene is missing player, test interactable or interaction HUD.")
		main_root.queue_free()
		quit(1)
		return

	player._on_sensor_area_entered(interactable)
	player._refresh_interaction_target()
	if not hud.is_prompt_visible():
		push_error("FAIL: nearby interactable did not show an interaction prompt.")
		main_root.queue_free()
		quit(1)
		return
	if not hud.get_prompt_text().ends_with(interactable.interaction_prompt):
		push_error("FAIL: HUD prompt does not match the interactable prompt.")
		main_root.queue_free()
		quit(1)
		return

	var result := player._try_interact()
	if result.is_empty() or not hud.is_feedback_visible() or hud.get_feedback_text() != result:
		push_error("FAIL: interaction result was not presented by the HUD.")
		main_root.queue_free()
		quit(1)
		return

	player._on_sensor_area_exited(interactable)
	player._refresh_interaction_target()
	if hud.is_prompt_visible():
		push_error("FAIL: interaction prompt remained visible after leaving the target.")
		main_root.queue_free()
		quit(1)
		return

	main_root.queue_free()
	print("[BTV interaction HUD] Prompt, interaction feedback and target exit passed.")
	quit(0)
