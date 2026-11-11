extends SceneTree
## Acceptance tests for the first authored Logos Rhema Sunday greybox.

const LogosRhemaScene = preload("res://scenes/logos_rhema_prototype.tscn")
var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var world := LogosRhemaScene.instantiate()
	root.add_child(world)
	await process_frame
	for _tick in range(12):
		await physics_frame

	_check(world.get_node_or_null("Player") is BTVPlayerController, "LOGOS_RHEMA: player controller is present")
	_check(world.get_node_or_null("TouchControls") is CanvasLayer, "LOGOS_RHEMA: mobile touch controls are present")
	_check(world.get_node_or_null("ServiceDirector") is BTVServiceDirector, "LOGOS_RHEMA: service director is present")
	_check(world.get_node_or_null("ChapelFloor") is StaticBody3D, "LOGOS_RHEMA: chapel floor has a static collision body")
	_check(world.get_node_or_null("WestWall/CollisionShape3D") is CollisionShape3D, "LOGOS_RHEMA: chapel wall has collision geometry")
	_check(world.get_node_or_null("Pew_0_-9/CollisionShape3D") is CollisionShape3D, "LOGOS_RHEMA: pews have collision geometry")
	_check(world.get_node_or_null("CommunionContextZone") is Area3D, "LOGOS_RHEMA: CommunionContextZone exists")
	_check(world.get_node_or_null("Pastor_Elias_Warrick_Greybox") is StaticBody3D, "LOGOS_RHEMA: named leader placeholder exists")
	_check(world.get_node_or_null("Congregant_00_Greybox") is StaticBody3D, "LOGOS_RHEMA: civilian placeholder exists")
	_check(world.get_node_or_null("Congregant_01_Interaction") is BTVChapelPersonInteractable, "LOGOS_RHEMA: congregant has an interaction area")
	_check(world.get_node_or_null("Pastor_Elias_Warrick_Interaction") is BTVChapelPersonInteractable, "LOGOS_RHEMA: named leader has an interaction area")
	_check(world.get_node_or_null("ServiceSequenceBoard") is BTVServicePhaseInteractable, "LOGOS_RHEMA: prototype service sequence interaction exists")
	_check(world.get_node_or_null("UnnamedVisitor") is BTVVisitorInteractable, "LOGOS_RHEMA: unnamed visitor interaction exists")

	var player := world.get_node("Player") as BTVPlayerController
	_check(player.is_on_floor(), "LOGOS_RHEMA: player settles onto chapel floor")
	_check(
		player.test_move(player.global_transform, Vector3(0.0, 0.0, 10.0)),
		"LOGOS_RHEMA: rear chapel wall blocks the player",
	)

	await _test_physical_chapel_collisions(player)
	await _test_npc_interaction(player, world)

	var director := world.get_node("ServiceDirector") as BTVServiceDirector
	_check(director.get_phase_count() == 13, "LOGOS_RHEMA: all thirteen approved service phases are represented")
	_check(director.get_phase_id() == "arrival_fellowship", "LOGOS_RHEMA: service begins with arrival and fellowship")
	_check(not director.is_service_complete(), "LOGOS_RHEMA: service is not auto-completed")
	_check(director.is_covenant_alert_pending(), "LOGOS_RHEMA: Covenant alert is queued")
	_check(not director.take_deliverable_covenant_alert(), "LOGOS_RHEMA: Covenant alert is gated before service completion")

	var visitor := world.get_node("UnnamedVisitor") as BTVVisitorInteractable
	var visitor_result := visitor.interact(player)
	_check(director.did_listen_to_visitor(), "LOGOS_RHEMA: optional visitor listening is recorded")
	_check(visitor_result.contains("remote") and not visitor_result.contains("Ridgeview"), "LOGOS_RHEMA: visitor clue preserves the unnamed location")

	for _phase_step in range(director.get_phase_count() - 1):
		director.advance_phase()
	_check(director.is_service_complete(), "LOGOS_RHEMA: service completes only after the final phase")
	_check(director.get_phase_id() == "fellowship_service", "LOGOS_RHEMA: final phase is fellowship and service")
	_check(director.advance_phase().contains("complete"), "LOGOS_RHEMA: completed service cannot advance beyond its final phase")
	director.set_communion_context_active(true)
	_check(not director.take_deliverable_covenant_alert(), "LOGOS_RHEMA: alert remains gated inside CommunionContextZone")
	director.set_communion_context_active(false)
	_check(director.take_deliverable_covenant_alert(), "LOGOS_RHEMA: queued alert becomes deliverable after service outside CommunionContextZone")
	_check(not director.is_covenant_alert_pending(), "LOGOS_RHEMA: delivered alert is no longer pending")

	player.global_position = Vector3(5.0, 0.0, -14.5)
	for _tick in range(4):
		await physics_frame
	_check(director.is_communion_context_active(), "LOGOS_RHEMA: entering the physical CommunionContextZone updates service context")
	player.global_position = Vector3(0.0, 0.0, 12.0)
	for _tick in range(4):
		await physics_frame
	_check(not director.is_communion_context_active(), "LOGOS_RHEMA: leaving CommunionContextZone clears service context")

	root.remove_child(world)
	world.free()
	print("\\nLOGOS_RHEMA_PROTOTYPE_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)


func _test_physical_chapel_collisions(player: BTVPlayerController) -> void:
	_check((player.collision_layer & 1) != 0, "LOGOS_RHEMA: player is registered on the world collision layer")
	_check((player.collision_mask & 1) != 0, "LOGOS_RHEMA: player queries the world collision layer")

	_clear_movement_actions()
	player.velocity = Vector3.ZERO
	player.rotation = Vector3.ZERO
	player.set("_camera_yaw_radians", 0.0)
	player.call("_sync_camera_yaw")
	player.global_position = Vector3(-12.0, 0.0, 0.0)
	for _tick in range(4):
		await physics_frame
	Input.action_press(&"move_left")
	for _tick in range(100):
		await physics_frame
	Input.action_release(&"move_left")
	_check(player.global_position.x > -13.6 and player.global_position.x < -12.5,
		"LOGOS_RHEMA: west wall physically blocks player movement")
	_check(player.is_on_wall(), "LOGOS_RHEMA: west-wall contact is reported by CharacterBody3D")

	_clear_movement_actions()
	player.velocity = Vector3.ZERO
	player.rotation = Vector3.ZERO
	player.global_position = Vector3(12.0, 0.0, 0.0)
	for _tick in range(4):
		await physics_frame
	Input.action_press(&"move_right")
	for _tick in range(100):
		await physics_frame
	Input.action_release(&"move_right")
	_check(player.global_position.x < 13.6 and player.global_position.x > 12.5,
		"LOGOS_RHEMA: east wall physically blocks player movement")
	_check(player.is_on_wall(), "LOGOS_RHEMA: east-wall contact is reported by CharacterBody3D")

	_clear_movement_actions()
	player.velocity = Vector3.ZERO
	player.rotation = Vector3.ZERO
	player.global_position = Vector3(-9.0, 0.0, 10.0)
	for _tick in range(4):
		await physics_frame
	Input.action_press(&"move_forward")
	for _tick in range(100):
		await physics_frame
	Input.action_release(&"move_forward")
	_check(player.global_position.z > 7.5 and player.global_position.z < 9.2,
		"LOGOS_RHEMA: pew row physically blocks forward movement")
	_check(player.is_on_wall(), "LOGOS_RHEMA: pew contact is reported by CharacterBody3D")

	_clear_movement_actions()
	player.velocity = Vector3.ZERO
	player.rotation = Vector3.ZERO
	player.global_position = Vector3(0.0, 0.0, -8.0)
	for _tick in range(4):
		await physics_frame
	Input.action_press(&"move_forward")
	for _tick in range(100):
		await physics_frame
	Input.action_release(&"move_forward")
	_check(player.global_position.z > -10.5 and player.global_position.z < -8.5,
		"LOGOS_RHEMA: stage physically blocks player movement")
	_check(player.is_on_wall(), "LOGOS_RHEMA: stage contact is reported by CharacterBody3D")

	_clear_movement_actions()
	player.velocity = Vector3.ZERO
	player.global_position = Vector3(0.0, 0.0, 12.0)
	for _tick in range(4):
		await physics_frame


func _clear_movement_actions() -> void:
	for action_name in [&"move_forward", &"move_back", &"move_left", &"move_right"]:
		Input.action_release(action_name)
	for action_name in [&"touch_move_forward", &"touch_move_back", &"touch_move_left", &"touch_move_right"]:
		Input.action_release(action_name)


func _test_npc_interaction(player: BTVPlayerController, world: Node3D) -> void:
	var congregant := world.get_node("Congregant_01_Interaction") as BTVChapelPersonInteractable
	player.velocity = Vector3.ZERO
	player.rotation = Vector3.ZERO
	player.set("_camera_yaw_radians", 0.0)
	player.call("_sync_camera_yaw")
	player.global_position = Vector3(-5.0, 0.0, 10.0)
	for _tick in range(5):
		await physics_frame
	var nearby: Array = player.get("_nearby_interactables")
	_check(nearby.has(congregant), "LOGOS_RHEMA: real interaction sensor detects an approachable congregant")
	_check(player.get_interaction_prompt() == "Speak with Congregant", "LOGOS_RHEMA: nearest NPC exposes a contextual interaction prompt")
	await process_frame
	_check(world.get_node("HUD/Prompt").visible, "LOGOS_RHEMA: interaction prompt is visible when an NPC is in range")
	_check(world.get_node("HUD/Prompt").text.contains("Speak with Congregant"), "LOGOS_RHEMA: HUD displays the nearest NPC action")
	var first_response: String = player.call("_try_interact")
	_check(first_response.contains("Welcome"), "LOGOS_RHEMA: speaking to an NPC returns a greeting")
	_check(world.get_node("HUD/Toast").text.contains("Welcome"), "LOGOS_RHEMA: NPC greeting reaches the on-screen interaction feedback")
	var second_response: String = player.call("_try_interact")
	_check(second_response.contains("fellowship"), "LOGOS_RHEMA: repeat interaction returns a contextual follow-up")
	_check(not first_response.is_empty() and not second_response.is_empty(), "LOGOS_RHEMA: NPC interaction remains repeatable without a reward loop")
	player.global_position = Vector3(0.0, 0.0, 12.0)
	for _tick in range(4):
		await physics_frame
