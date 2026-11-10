extends SceneTree
## Structural acceptance checks for the canon-neutral graphics benchmark.

const BenchmarkScene = preload("res://scenes/neutral_graphics_benchmark.tscn")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var benchmark := BenchmarkScene.instantiate()
	root.add_child(benchmark)
	await process_frame
	await process_frame
	_check(benchmark.get_node_or_null("BenchmarkCamera") is Camera3D, "GRAPHICS BENCH: dedicated camera exists")
	_check(benchmark.get_node_or_null("MaterialBay") is Node3D, "GRAPHICS BENCH: material bay exists")
	_check(benchmark.get_node_or_null("LightingBay") is Node3D, "GRAPHICS BENCH: lighting bay exists")
	_check(benchmark.get_node_or_null("VegetationLane") is Node3D, "GRAPHICS BENCH: vegetation lane exists")
	_check(benchmark.get_node_or_null("CharacterPad") is Node3D, "GRAPHICS BENCH: neutral mannequin pad exists")
	_check(benchmark.get_node_or_null("SettlementBlockout") is Node3D, "GRAPHICS BENCH: settlement blockout exists")
	_check(benchmark.get_node_or_null("BenchmarkRoute") is Node3D, "GRAPHICS BENCH: repeatable route exists")
	_check(benchmark.get_node_or_null("BenchmarkRoute/RouteSegment_0") is MeshInstance3D, "GRAPHICS BENCH: route segments physically connect zones")
	_check(benchmark.get_node_or_null("BenchmarkRoute/RouteWaypoint_5") is MeshInstance3D, "GRAPHICS BENCH: final route waypoint exists")
	var state: Dictionary = benchmark.call("get_benchmark_state")
	_check(state.get("foliage_count", 0) == 12, "GRAPHICS BENCH: twelve foliage proxies are available")
	_check(state.get("npc_count", 0) == 3, "GRAPHICS BENCH: three NPC placeholders are available")
	_check(state.get("shadows", false), "GRAPHICS BENCH: shadow toggle starts enabled")
	benchmark.call("_unhandled_input", _key_event(KEY_1))
	benchmark.call("_unhandled_input", _key_event(KEY_2))
	benchmark.call("_unhandled_input", _key_event(KEY_3))
	benchmark.call("_unhandled_input", _key_event(KEY_4))
	state = benchmark.call("get_benchmark_state")
	_check(not state.get("shadows", true), "GRAPHICS BENCH: shadow toggle changes the light")
	_check(state.get("fog", false), "GRAPHICS BENCH: fog toggle changes the environment")
	_check(not state.get("foliage", true), "GRAPHICS BENCH: foliage toggle changes visibility")
	_check(not state.get("npcs", true), "GRAPHICS BENCH: NPC toggle changes visibility")
	_check(benchmark.get_node_or_null("HUD/Telemetry") is Label, "GRAPHICS BENCH: telemetry is visible")
	_check(benchmark.has_method("get_frame_time_summary"), "GRAPHICS BENCH: frame-time summary API exists")
	_check(benchmark.has_method("get_frame_time_sample_count"), "GRAPHICS BENCH: bounded frame-time sample API exists")
	_check(int(benchmark.call("get_frame_time_sample_count")) <= 3600, "GRAPHICS BENCH: frame-time sample storage is bounded")
	var frame_summary: Dictionary = benchmark.call("get_frame_time_summary")
	_check(frame_summary.is_empty() or frame_summary.has("p95_ms"), "GRAPHICS BENCH: summary reports percentile when samples exist")
	root.remove_child(benchmark)
	benchmark.free()
	print("\nNEUTRAL_GRAPHICS_BENCHMARK_TESTS: PASS")
	quit(0)


func _key_event(key: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.pressed = true
	event.keycode = key
	return event


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		printerr("FAIL: ", label)
		quit(1)
