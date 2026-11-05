extends SceneTree

const PlayerScene = preload("res://scenes/player.tscn")
const RecordingInteractable = preload("res://tests/fixtures/recording_interactable.gd")

var failures := 0
var player: CharacterBody3D

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_no_target_is_safe()
	_test_single_target_is_invoked_once()
	_test_nearest_target_wins()
	_test_exit_clears_target()
	_test_freed_target_is_safe()
	_test_disabled_target_is_excluded()
	_test_duplicate_authored_ids_are_excluded()
	_test_selection_api_and_stable_tie_break_are_present()
	if failures == 0:
		print("CORE_INTERACTION_ACCEPTANCE_TESTS: PASS")
		quit(0)
	else:
		printerr("CORE_INTERACTION_ACCEPTANCE_TESTS: FAIL (", failures, " failures)")
		quit(1)

func _new_player() -> CharacterBody3D:
	var instance := PlayerScene.instantiate() as CharacterBody3D
	root.add_child(instance)
	return instance

func _new_target(target_id: String, position: Vector3) -> Area3D:
	var target := RecordingInteractable.new() as Area3D
	target.set("interaction_id", target_id)
	target.position = position
	root.add_child(target)
	return target

func _test_no_target_is_safe() -> void:
	player = _new_player()
	player.call("_try_interact")
	_check(true, "No target produces a safe no-op")
	player.queue_free()

func _test_single_target_is_invoked_once() -> void:
	player = _new_player()
	var target := _new_target("target-a", Vector3(0, 0, -1))
	player.call("_on_sensor_area_entered", target)
	player.call("_try_interact")
	_check(int(target.get("interaction_count")) == 1, "One eligible target receives one interaction")
	_check(target.get("last_actor") == player, "Interaction receives the player as actor")
	player.queue_free()
	target.queue_free()

func _test_nearest_target_wins() -> void:
	player = _new_player()
	var far_target := _new_target("far", Vector3(0, 0, -2))
	var near_target := _new_target("near", Vector3(0, 0, -1))
	player.call("_on_sensor_area_entered", far_target)
	player.call("_on_sensor_area_entered", near_target)
	player.call("_try_interact")
	_check(int(near_target.get("interaction_count")) == 1, "Nearest target is selected")
	_check(int(far_target.get("interaction_count")) == 0, "Farther target is not invoked")
	player.queue_free()
	far_target.queue_free()
	near_target.queue_free()

func _test_exit_clears_target() -> void:
	player = _new_player()
	var target := _new_target("leaving", Vector3(0, 0, -1))
	player.call("_on_sensor_area_entered", target)
	player.call("_on_sensor_area_exited", target)
	player.call("_try_interact")
	_check(int(target.get("interaction_count")) == 0, "Exited target is no longer interactable")
	player.queue_free()
	target.queue_free()

func _test_freed_target_is_safe() -> void:
	player = _new_player()
	var target := _new_target("freed", Vector3(0, 0, -1))
	player.call("_on_sensor_area_entered", target)
	root.remove_child(target)
	target.free()
	player.call("_try_interact")
	_check(true, "Freed target reference is ignored safely")
	player.queue_free()

func _test_disabled_target_is_excluded() -> void:
	player = _new_player()
	var target := _new_target("disabled", Vector3(0, 0, -1))
	target.set("interaction_enabled", false)
	player.call("_on_sensor_area_entered", target)
	player.call("_try_interact")
	_check(int(target.get("interaction_count")) == 0, "Disabled target is immediately ineligible")
	player.queue_free()
	target.queue_free()


func _test_duplicate_authored_ids_are_excluded() -> void:
	player = _new_player()
	var first := _new_target("duplicate", Vector3(0, 0, -1))
	var second := _new_target("duplicate", Vector3(0, 0, -1.5))
	player.call("_on_sensor_area_entered", first)
	player.call("_on_sensor_area_entered", second)
	player.call("_try_interact")
	_check(int(first.get("interaction_count")) == 0 and int(second.get("interaction_count")) == 0, "Duplicate authored IDs are excluded instead of selecting nondeterministically")
	player.queue_free()
	first.queue_free()
	second.queue_free()


func _test_selection_api_and_stable_tie_break_are_present() -> void:
	player = _new_player()
	var has_selector := player.has_method("_select_nearest_interactable")
	_check(has_selector, "Controller exposes deterministic selection seam for acceptance tests")
	if has_selector:
		var alpha := _new_target("alpha", Vector3(0, 0, -1))
		var zeta := _new_target("zeta", Vector3(0, 0, -1))
		player.call("_on_sensor_area_entered", zeta)
		player.call("_on_sensor_area_entered", alpha)
		var selected = player.call("_select_nearest_interactable")
		_check(selected == alpha, "Equal-distance tie resolves by stable authored interaction ID")
		alpha.queue_free()
		zeta.queue_free()
	player.queue_free()

func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
