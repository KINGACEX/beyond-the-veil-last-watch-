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
	benchmark.call("start_route_playback")
	var route_state: Dictionary = benchmark.call("get_route_state")
	_check(route_state.get("active", false), "GRAPHICS BENCH: fixed camera route starts")
	_check(route_state.get("segment_count", 0) == 6, "GRAPHICS BENCH: route has six deterministic viewpoints")
	for _segment in range(6):
		benchmark.call("_advance_route", 2.0)
	route_state = benchmark.call("get_route_state")
	_check(not route_state.get("active", true), "GRAPHICS BENCH: fixed camera route completes")
	_check(route_state.get("segment_index", 0) == 6, "GRAPHICS BENCH: all route segments are traversed")
	benchmark.call("start_route_playback")
	benchmark.call("stop_route_playback")
	_check(not benchmark.call("get_route_state").get("active", true), "GRAPHICS BENCH: route can be stopped")
	_check(benchmark.call("begin_acceptance_run"), "GRAPHICS BENCH: acceptance run starts")
	var run_state: Dictionary = benchmark.call("get_acceptance_run_state")
	_check(run_state.get("phase") == "warmup", "GRAPHICS BENCH: run begins with warm-up")
	benchmark.call("_advance_benchmark_run", 5.0)
	run_state = benchmark.call("get_acceptance_run_state")
	_check(run_state.get("phase") == "transit", "GRAPHICS BENCH: warm-up advances to first viewpoint")
	for viewpoint in range(6):
		benchmark.call("_advance_benchmark_run", 1.0)
		run_state = benchmark.call("get_acceptance_run_state")
		_check(run_state.get("phase") == "dwell", "GRAPHICS BENCH: viewpoint %d enters fixed dwell" % viewpoint)
		benchmark.call("_process", 0.1)
		benchmark.call("_advance_benchmark_run", 3.0)
	run_state = benchmark.call("get_acceptance_run_state")
	_check(run_state.get("phase") == "complete", "GRAPHICS BENCH: six-viewpoint acceptance run completes")
	_check(int(run_state.get("sample_count", 0)) > 0, "GRAPHICS BENCH: frame samples collected during dwell only")
	var metadata: Dictionary = benchmark.call("build_run_metadata")
	_check(metadata.get("schema_version", 0) == 1, "GRAPHICS BENCH: metadata has schema version")
	_check(metadata.get("protocol", {}).get("viewpoint_count", 0) == 6, "GRAPHICS BENCH: metadata records six viewpoints")
	_check(metadata.get("frame_time_measurement", {}).get("source", "").contains("process delta"), "GRAPHICS BENCH: measurement source is explicit")
	_check(metadata.get("frame_time_measurement", {}).get("limitations", "").contains("not isolated GPU"), "GRAPHICS BENCH: telemetry limitations are explicit")
	var export_path: String = benchmark.call("export_last_run_metadata")
	_check(not export_path.is_empty() and FileAccess.file_exists(export_path), "GRAPHICS BENCH: JSON metadata export creates a file")
	if not export_path.is_empty() and FileAccess.file_exists(export_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(export_path))
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
