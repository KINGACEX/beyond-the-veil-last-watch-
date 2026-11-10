extends Node3D
## Neutral, non-production wildlife validation lab.
## Proxy markers represent scheduler workload only; they are not animal assets.

const Ecology = preload("res://scripts/wildlife_ecology_sim.gd")

@onready var _telemetry: Label = $HUD/Telemetry
var _agents: Array[MeshInstance3D] = []
var _distances: Array[float] = []
var _tick_accumulator := 0.0
var _frame_index := 0
const UPDATE_INTERVAL := 0.25
const NEAR_RADIUS := 5.0
const MID_RADIUS := 15.0
const FAR_RADIUS := 40.0
const BUDGETS := {"near": 2, "mid": 2, "far": 1, "offscreen": 1}


func _ready() -> void:
	_build_lab()
	_update_scheduler()


func _process(delta: float) -> void:
	_tick_accumulator += delta
	if _tick_accumulator < UPDATE_INTERVAL:
		return
	_tick_accumulator = fmod(_tick_accumulator, UPDATE_INTERVAL)
	_frame_index += 1
	_update_scheduler()


func _build_lab() -> void:
	var floor_body := StaticBody3D.new()
	floor_body.name = "NeutralFloor"
	var floor_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(58.0, 0.5, 22.0)
	floor_shape.shape = box
	floor_body.add_child(floor_shape)
	var floor_mesh := MeshInstance3D.new()
	var floor_box := BoxMesh.new()
	floor_box.size = box.size
	floor_mesh.mesh = floor_box
	var floor_material := StandardMaterial3D.new()
	floor_material.albedo_color = Color(0.18, 0.20, 0.22)
	floor_material.roughness = 1.0
	floor_mesh.material_override = floor_material
	floor_body.add_child(floor_mesh)
	floor_body.position = Vector3(0.0, -0.25, 0.0)
	add_child(floor_body)

	var tier_layout := [
		{"tier": "near", "distances": [2.0, 3.5, 4.5], "origin": Vector3(-18.0, 0.8, 0.0), "color": Color(0.3, 0.85, 0.45)},
		{"tier": "mid", "distances": [8.0, 11.0, 14.0], "origin": Vector3(-6.0, 0.8, 0.0), "color": Color(0.3, 0.7, 0.95)},
		{"tier": "far", "distances": [22.0, 30.0], "origin": Vector3(8.0, 0.8, 0.0), "color": Color(0.95, 0.75, 0.3)},
		{"tier": "offscreen", "distances": [55.0, 70.0], "origin": Vector3(23.0, 0.8, 0.0), "color": Color(0.72, 0.55, 0.85)},
	]
	for tier_data in tier_layout:
		var tier_name: String = tier_data.tier
		var tier_origin: Vector3 = tier_data.origin
		var tier_color: Color = tier_data.color
		var distance_list: Array = tier_data.distances
		for index in range(distance_list.size()):
			var distance_value := float(distance_list[index])
			_distances.append(distance_value)
			var proxy := MeshInstance3D.new()
			proxy.name = "Proxy_%s_%02d" % [tier_name, index]
			var mesh := SphereMesh.new()
			mesh.radius = 0.48
			mesh.height = 0.96
			proxy.mesh = mesh
			proxy.position = tier_origin + Vector3(0.0, 0.0, float(index) * 2.0 - float(distance_list.size() - 1))
			var material := StandardMaterial3D.new()
			material.albedo_color = tier_color
			material.roughness = 0.85
			material.emission_enabled = true
			material.emission = tier_color * 0.12
			proxy.material_override = material
			proxy.set_meta("simulation_tier", tier_name)
			add_child(proxy)
			_agents.append(proxy)


func _update_scheduler() -> void:
	var result: Dictionary = Ecology.schedule_updates(
		_distances, NEAR_RADIUS, MID_RADIUS, FAR_RADIUS, BUDGETS, _frame_index
	)
	var selected: Array = result.get("selected_indices", [])
	var selected_lookup := {}
	for index_value in selected:
		selected_lookup[int(index_value)] = true
	for index in range(_agents.size()):
		var material := _agents[index].material_override as StandardMaterial3D
		var base_color := material.albedo_color
		material.emission = base_color * (0.42 if selected_lookup.has(index) else 0.08)
	var counts: Dictionary = result.get("tier_counts", {})
	_telemetry.text = (
		"NON-PRODUCTION WILDLIFE LOD LAB\n"
		+ "Proxy agents: %d   Scheduled this tick: %d\n" % [_agents.size(), selected.size()]
		+ "Near: %d   Mid: %d   Far: %d   Off-screen: %d\n" % [
			counts.get("near", 0), counts.get("mid", 0), counts.get("far", 0), counts.get("offscreen", 0)
		]
		+ "Budget: 2 / 2 / 1 / 1   Tick: %.2f s\n" % UPDATE_INTERVAL
		+ "Bright markers = scheduled this tick; dim markers = deferred.\n"
		+ "Proxy workload only: no animal models, navigation or production spawning."
	)


func get_agent_count() -> int:
	return _agents.size()


func get_scheduled_count() -> int:
	return int(_telemetry.text.get_slice("Scheduled this tick: ", 1).get_slice("\n", 0))
