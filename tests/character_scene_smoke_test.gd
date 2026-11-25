extends SceneTree

var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	_check(packed != null, "Main scene resource loads")
	if packed == null:
		quit(1)
		return

	var instance := packed.instantiate()
	root.add_child(instance)
	await process_frame
	await physics_frame
	await physics_frame

	var player := instance.get_node_or_null("Player")
	var resident := instance.get_node_or_null("RidgeviewResident")
	var hud := instance.get_node_or_null("GameHUD")
	_check(player != null, "Asher player node exists")
	_check(resident != null, "Ridgeview resident NPC exists")
	_check(hud != null, "On-screen game HUD exists")

	if player != null:
		var player_model := player.get_node_or_null("Visual/CharacterModel")
		_check(player_model != null, "Asher 3D character model is built")
		if player_model != null:
			_check(player_model.get_child_count() >= 15, "Asher model has authored visual parts")

	if resident != null:
		var resident_model := resident.get_node_or_null("Visual/CharacterModel")
		_check(resident_model != null, "Resident 3D character model is built")
		if resident_model != null:
			_check(resident_model.get_child_count() >= 15, "Resident model has authored visual parts")

	if player != null and hud != null:
		player._try_interact()
		await process_frame
		var message := hud.get_node("Root/MessagePanel/Message") as Label
		_check(message.text.contains("Resident:"), "Interaction response appears in the HUD")

	print("CHARACTER_SCENE_SMOKE_TESTS: ", "PASS" if _failures == 0 else "FAIL")
	quit(0 if _failures == 0 else 1)


func _check(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)
