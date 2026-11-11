extends SceneTree
## Structural acceptance checks for the canon-neutral graphics benchmark.

const BenchmarkScene = preload("res://scenes/neutral_graphics_benchmark.tscn")
var failures := 0


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
	_check(state.get("quality_profile") == "reference", "GRAPHICS BENCH: reference scene profile is the default")
	_check(state.get("supported_quality_profiles", []).size() == 3, "GRAPHICS BENCH: three supported scene profiles are exposed")
	_check(benchmark.call("set_quality_profile", "reduced"), "GRAPHICS BENCH: reduced scene profile is supported")
	state = benchmark.call("get_benchmark_state")
	_check(state.get("quality_profile") == "reduced" and not state.get("fog", true) and not state.get("npcs", true), "GRAPHICS BENCH: reduced profile applies its declared settings")
	_check(benchmark.call("set_quality_profile", "minimal"), "GRAPHICS BENCH: minimal scene profile is supported")
	state = benchmark.call("get_benchmark_state")
	_check(not state.get("shadows", true) and not state.get("foliage", true), "GRAPHICS BENCH: minimal profile disables shadow and foliage proxies")
	_check(not benchmark.call("set_quality_profile", "ultra"), "GRAPHICS BENCH: unsupported scene profile is rejected")
	_check(benchmark.call("set_quality_profile", "reference"), "GRAPHICS BENCH: reference profile can be restored")
	benchmark.call("_unhandled_input", _key_event(KEY_1))
	benchmark.call("_unhandled_input", _key_event(KEY_2))
	benchmark.call("_unhandled_input", _key_event(KEY_3))
	benchmark.call("_unhandled_input", _key_event(KEY_4))
	state = benchmark.call("get_benchmark_state")
	_check(not state.get("shadows", true), "GRAPHICS BENCH: shadow toggle changes the light")
	_check(state.get("fog", false), "GRAPHICS BENCH: fog toggle changes the environment")
	_check(not state.get("foliage", true), "GRAPHICS BENCH: foliage toggle changes visibility")
	_check(not state.get("npcs", true), "GRAPHICS BENCH: NPC toggle changes visibility")
	_check(benchmark.call("set_render_scale", 0.85), "GRAPHICS BENCH: supported render scale can be selected")
	_check(is_equal_approx(benchmark.get_viewport().scaling_3d_scale, 0.85), "GRAPHICS BENCH: viewport 3D buffer scale changes")
	_check(not benchmark.call("set_render_scale", 0.5), "GRAPHICS BENCH: unsupported render scale is rejected")
	_check(is_equal_approx(benchmark.get_viewport().scaling_3d_scale, 0.85), "GRAPHICS BENCH: rejected scale leaves active scale unchanged")
	_check(benchmark.call("cycle_render_scale"), "GRAPHICS BENCH: render-scale preset cycle is available")
	_check(is_equal_approx(benchmark.get_viewport().scaling_3d_scale, 0.7), "GRAPHICS BENCH: render-scale cycle selects the next supported preset")
	_check(benchmark.call("cycle_render_scale"), "GRAPHICS BENCH: render-scale preset cycle wraps")
	_check(is_equal_approx(benchmark.get_viewport().scaling_3d_scale, 1.0), "GRAPHICS BENCH: render-scale cycle returns to native scale")
	_check(benchmark.call("set_render_scale", 1.0), "GRAPHICS BENCH: native render scale can be restored")
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
	_check(int(run_state.get("viewpoint_index", -1)) == 0, "GRAPHICS BENCH: warm-up is anchored at viewpoint zero")
	_check(int(run_state.get("sample_count", -1)) == 0, "GRAPHICS BENCH: a new run clears prior samples")
	benchmark.call("_process", 0.1)
	_check(int(benchmark.call("get_frame_time_sample_count")) == 0, "GRAPHICS BENCH: warm-up intervals are excluded")
	benchmark.call("_advance_benchmark_run", 4.9)
	run_state = benchmark.call("get_acceptance_run_state")
	_check(run_state.get("phase") == "dwell", "GRAPHICS BENCH: warm-up transitions into the first fixed dwell")
	var first_camera_target: Vector3 = benchmark.get("_route_points")[0]
	_check(benchmark.get_node("BenchmarkCamera").position.distance_to(first_camera_target + Vector3(0.0, 11.0, 15.0)) < 0.001, "GRAPHICS BENCH: first dwell camera position is fixed")
	for viewpoint in range(6):
		if viewpoint > 0:
			var samples_before_transit := int(benchmark.call("get_frame_time_sample_count"))
			var transition_start: Vector3 = benchmark.get_node("BenchmarkCamera").position
			benchmark.call("_advance_benchmark_run", 0.5)
			var transition_midpoint: Vector3 = benchmark.get_node("BenchmarkCamera").position
			_check(transition_midpoint.distance_to(transition_start) > 0.01, "GRAPHICS BENCH: camera moves between fixed dwell points")
			benchmark.call("_process", 0.1)
			_check(int(benchmark.call("get_frame_time_sample_count")) == samples_before_transit, "GRAPHICS BENCH: camera transit intervals are excluded")
			benchmark.call("_advance_benchmark_run", 0.4)
			run_state = benchmark.call("get_acceptance_run_state")
			_check(run_state.get("phase") == "dwell", "GRAPHICS BENCH: viewpoint %d reaches its dwell after transit" % viewpoint)
		var route_points: Array = benchmark.get("_route_points")
		var dwell_target: Vector3 = route_points[viewpoint]
		_check(benchmark.get_node("BenchmarkCamera").position.distance_to(dwell_target + Vector3(0.0, 11.0, 15.0)) < 0.001, "GRAPHICS BENCH: viewpoint %d camera settles at its fixed dwell point" % viewpoint)
		benchmark.call("_process", 0.1)
		_check(int(benchmark.call("get_frame_time_sample_count")) == viewpoint + 1, "GRAPHICS BENCH: dwell-only sample count advances at viewpoint %d" % viewpoint)
		benchmark.call("_advance_benchmark_run", 2.9)
	run_state = benchmark.call("get_acceptance_run_state")
	_check(run_state.get("phase") == "complete", "GRAPHICS BENCH: six-viewpoint acceptance run completes")
	_check(int(run_state.get("sample_count", 0)) == 6, "GRAPHICS BENCH: one deterministic test sample was recorded per dwell")
	var metadata: Dictionary = benchmark.call("build_run_metadata")
	_check(metadata.get("schema_version", 0) == 3, "GRAPHICS BENCH: metadata schema version is explicit")
	_check(metadata.get("protocol", {}).get("viewpoint_count", 0) == 6, "GRAPHICS BENCH: metadata records six viewpoints")
	_check(metadata.get("protocol", {}).get("warmup_location", "").contains("viewpoint_00"), "GRAPHICS BENCH: metadata pins warm-up to the first fixed viewpoint")
	_check(metadata.get("protocol", {}).get("sampling_policy", "").contains("transit intervals excluded"), "GRAPHICS BENCH: metadata records dwell-only sampling")
	_check(metadata.get("rendering", {}).get("supported_quality_profiles", []).size() == 3, "GRAPHICS BENCH: metadata lists supported scene profiles")
	_check(metadata.get("rendering", {}).get("supported_render_scales", []).size() == 3, "GRAPHICS BENCH: metadata lists supported render scales")
	_check(metadata.get("rendering", {}).get("quality_profile") == "reference", "GRAPHICS BENCH: metadata records active scene profile")
	_check(metadata.get("run", {}).get("comparison_key", "").contains("reference_render_scale_1.00"), "GRAPHICS BENCH: comparison key includes profile and render scale")
	_check(is_equal_approx(float(metadata.get("run", {}).get("duration_seconds", -1.0)), 28.0), "GRAPHICS BENCH: run duration matches warm-up, dwell and transit protocol")
	_check(metadata.get("frame_time_measurement", {}).get("source", "").contains("process delta"), "GRAPHICS BENCH: measurement source is explicit")
	_check(metadata.get("frame_time_measurement", {}).get("scope", "").contains("not CPU execution time"), "GRAPHICS BENCH: frame interval is not mislabelled as CPU execution time")
	_check(metadata.get("frame_time_measurement", {}).get("limitations", "").contains("not isolated GPU"), "GRAPHICS BENCH: telemetry limitations are explicit")
	_check(metadata.get("telemetry_availability", {}).get("cpu_frame_delta_ms", {}).get("definition", "").contains("not CPU execution time"), "GRAPHICS BENCH: frame delta is not CPU execution duration")
	_check(not metadata.get("telemetry_availability", {}).get("cpu_utilization", {}).get("available", true), "GRAPHICS BENCH: CPU utilization is explicitly unavailable")
	_check(not metadata.get("telemetry_availability", {}).get("gpu_frame_time_ms", {}).get("available", true), "GRAPHICS BENCH: GPU frame time is explicitly unavailable")
	_check(not metadata.get("telemetry_availability", {}).get("gpu_utilization", {}).get("available", true), "GRAPHICS BENCH: GPU utilization is explicitly unavailable")
	_check(not metadata.get("telemetry_availability", {}).get("process_memory_bytes", {}).get("available", true), "GRAPHICS BENCH: process memory is explicitly unavailable")
	_check(not metadata.get("telemetry_availability", {}).get("gpu_memory_bytes", {}).get("available", true), "GRAPHICS BENCH: GPU memory is explicitly unavailable")
	_check(not metadata.get("telemetry_availability", {}).get("thermal_state", {}).get("available", true), "GRAPHICS BENCH: thermal state is explicitly unavailable")
	_check(is_equal_approx(float(metadata.get("rendering", {}).get("render_scale", -1.0)), 1.0), "GRAPHICS BENCH: active render scale is exported")
	var export_path: String = benchmark.call("export_last_run_metadata")
	_check(not export_path.is_empty() and FileAccess.file_exists(export_path), "GRAPHICS BENCH: JSON metadata export creates a file")
	if not export_path.is_empty() and FileAccess.file_exists(export_path):
		var exported_file := FileAccess.open(export_path, FileAccess.READ)
		var exported_text := exported_file.get_as_text() if exported_file != null else ""
		if exported_file != null:
			exported_file.close()
		var exported_value: Variant = JSON.parse_string(exported_text)
		_check(not exported_text.is_empty(), "GRAPHICS BENCH: exported JSON is not empty")
		_check(exported_value is Dictionary and exported_value.has("telemetry_availability"), "GRAPHICS BENCH: exported JSON retains telemetry availability boundaries")
		if exported_value is Dictionary:
			_check(exported_value.get("schema_version") == 3, "GRAPHICS BENCH: exported JSON preserves the current schema")
			_check(exported_value.get("rendering", {}).get("quality_profile") == "reference", "GRAPHICS BENCH: exported JSON preserves active comparison settings")
			_check(not exported_value.get("telemetry_availability", {}).get("thermal_state", {}).get("available", true), "GRAPHICS BENCH: exported JSON does not invent thermal telemetry")
		DirAccess.remove_absolute(ProjectSettings.globalize_path(export_path))
	_check(benchmark.call("begin_acceptance_run"), "GRAPHICS BENCH: repeat run can be started")
	run_state = benchmark.call("get_acceptance_run_state")
	_check(run_state.get("sequence") == 2 and run_state.get("phase") == "warmup", "GRAPHICS BENCH: repeat run increments sequence and restarts warm-up")
	_check(run_state.get("sample_count") == 0, "GRAPHICS BENCH: repeat run clears the previous sample window")
	var repeat_camera_target: Vector3 = benchmark.get("_route_points")[0]
	_check(benchmark.get_node("BenchmarkCamera").position.distance_to(repeat_camera_target + Vector3(0.0, 11.0, 15.0)) < 0.001, "GRAPHICS BENCH: repeat run resets to the same first dwell camera point")
	root.remove_child(benchmark)
	benchmark.free()
	print("\nNEUTRAL_GRAPHICS_BENCHMARK_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _key_event(key: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.pressed = true
	event.keycode = key
	return event


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
