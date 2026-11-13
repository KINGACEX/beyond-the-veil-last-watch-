extends SceneTree

const PLAYTEST_SCENE := "res://scenes/covenant_hq/covenant_headquarters_playtest_001.tscn"

func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load(PLAYTEST_SCENE) as PackedScene
	if packed == null:
		push_error("FAIL: HQ playtest scene did not load for reception NPC test.")
		quit(1)
		return

	var playtest_root := packed.instantiate()
	root.add_child(playtest_root)
	var player := playtest_root.get_node_or_null("Player") as BTVPlayerController
	var officer := playtest_root.get_node_or_null("ReceptionOfficer") as BTVHQReceptionOfficer
	var hud := playtest_root.get_node_or_null("InteractionHUD") as BTVInteractionHUD
	if player == null or officer == null or hud == null:
		push_error("FAIL: HQ playtest scene is missing the player, reception officer or HUD.")
		playtest_root.queue_free()
		quit(1)
		return

	player._on_sensor_area_entered(officer)
	player._refresh_interaction_target()
	if not hud.is_prompt_visible() or not hud.get_prompt_text().ends_with(officer.interaction_prompt):
		push_error("FAIL: reception officer prompt is not presented.")
		playtest_root.queue_free()
		quit(1)
		return

	var first_response := player._try_interact()
	if not first_response.contains("Welcome") or not first_response.contains("operations room"):
		push_error("FAIL: reception officer first greeting is incorrect.")
		playtest_root.queue_free()
		quit(1)
		return
	if hud.get_feedback_text() != first_response:
		push_error("FAIL: reception officer response was not presented by the HUD.")
		playtest_root.queue_free()
		quit(1)
		return

	var repeat_response := player._try_interact()
	if not repeat_response.contains("Need directions"):
		push_error("FAIL: reception officer repeat response did not reflect prior interaction.")
		playtest_root.queue_free()
		quit(1)
		return

	player._on_sensor_area_exited(officer)
	player._refresh_interaction_target()
	if hud.is_prompt_visible():
		push_error("FAIL: reception prompt remained visible after leaving the interaction area.")
		playtest_root.queue_free()
		quit(1)
		return

	playtest_root.queue_free()
	print("[BTV HQ NPC] Reception prompt, contextual greeting and repeat response passed.")
	quit(0)
