extends Node3D

const VisualLOD = preload("res://scripts/wildlife_visual_lod.gd")
## Isolated wildlife visual study. All forms are generic placeholders, not species assets.
## No species placement, navigation, hunting, capture or combat is implemented.

@onready var _telemetry: Label = $HUD/Telemetry

var _elapsed := 0.0
var _specimens: Dictionary = {}
var _base_positions: Dictionary = {}
var _moving_parts: Dictionary = {}
var _habitat_roots: Dictionary = {}
var _visual_lod_tiers: Dictionary = {}
var _lod_refresh_elapsed := 0.0
var _animation_mode := "idle"
const LOD_REFRESH_SECONDS := 0.25
const LOCOMOTION_LOOP_SECONDS := 6.0
const LOCOMOTION_TRAVEL_SECONDS := 2.0
const ENDPOINT_IDLE_SECONDS := 1.0


func _ready() -> void:
	_build_floor()
	_build_habitat_presentations()
	_build_mammal_study()
	_build_bird_study()
	_build_reptile_study()
	_update_telemetry()
	var active_camera := get_viewport().get_camera_3d()
	if active_camera != null:
		update_visual_lod_for_camera(active_camera.global_position)


func _process(delta: float) -> void:
	if is_finite(delta) and delta > 0.0:
		_elapsed += delta
		_lod_refresh_elapsed += delta
	if _lod_refresh_elapsed >= LOD_REFRESH_SECONDS:
		_lod_refresh_elapsed = fposmod(_lod_refresh_elapsed, LOD_REFRESH_SECONDS)
		var active_camera := get_viewport().get_camera_3d()
		if active_camera != null:
			update_visual_lod_for_camera(active_camera.global_position)
	_animate_specimens()


func _update_telemetry() -> void:
	_telemetry.text = (
		"WILDLIFE VISUAL PROTOTYPE LAB — GENERIC PLACEHOLDERS\n"
		+ "Fur-like / feather-like / scale-like surface studies; no species identity\n"
		+ "Deterministic idle + short locomotion loops; no navigation or physics\n"
		+ "Woodland / open-perch / rocky-shelf set dressing is presentation-only\n"
		+ "Near / mid / far / off visual detail is separate from ecology simulation LOD\n"
		+ "Evidence gate: cited species profile + uncertainty notes required; none assigned\n"
		+ "Nonviolent observation only; no hunting, capture, injury or combat."
	)


func _build_floor() -> void:
	var floor := MeshInstance3D.new()
	floor.name = "NeutralFloor"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(42.0, 0.25, 15.0)
	floor.mesh = mesh
	floor.position = Vector3(0.0, -0.14, 0.0)
	floor.material_override = _make_material(Color(0.17, 0.19, 0.20), 1.0)
	add_child(floor)


func _new_habitat_root(root_name: String, root_position: Vector3) -> Node3D:
	var habitat := Node3D.new()
	habitat.name = root_name
	habitat.position = root_position
	habitat.set_meta("presentation_only", true)
	habitat.set_meta("species_assignment", "none")
	habitat.set_meta("evidence_status", "not_species_evidence")
	_habitat_roots[root_name] = habitat
	add_child(habitat)
	return habitat


func _add_habitat_pad(parent: Node3D, pad_name: String, color: Color) -> void:
	var pad := MeshInstance3D.new()
	pad.name = pad_name
	var mesh := BoxMesh.new()
	mesh.size = Vector3(10.8, 0.12, 14.0)
	pad.mesh = mesh
	pad.position = Vector3(0.0, -0.08, 0.0)
	pad.material_override = _make_material(color, 0.96)
	parent.add_child(pad)


func _build_habitat_presentations() -> void:
	var woodland := _new_habitat_root("Habitat_WoodlandPresentation", Vector3(-12.0, 0.0, 0.0))
	_add_habitat_pad(woodland, "WoodlandPad", Color(0.18, 0.25, 0.15))
	var grass_material := _make_material(Color(0.25, 0.39, 0.18), 0.98)
	var grass_positions := [
		Vector3(-4.0, 0.17, -2.8), Vector3(-2.6, 0.17, 2.8),
		Vector3(2.8, 0.17, -2.6), Vector3(4.0, 0.17, 2.5),
	]
	for index in range(grass_positions.size()):
		var blade := MeshInstance3D.new()
		blade.name = "GrassBlade_%02d" % index
		var blade_mesh := CylinderMesh.new()
		blade_mesh.top_radius = 0.012
		blade_mesh.bottom_radius = 0.035
		blade_mesh.height = 0.42 + float(index % 2) * 0.08
		blade.mesh = blade_mesh
		blade.position = grass_positions[index]
		blade.rotation.z = deg_to_rad(float(index % 3) * 8.0 - 8.0)
		blade.material_override = grass_material
		woodland.add_child(blade)
	add_child(_make_label("WOODLAND FLOOR — PRESENTATION ONLY", Vector3(-17.0, 2.85, -5.4)))

	var open_perch := _new_habitat_root("Habitat_OpenPerchPresentation", Vector3(0.0, 0.0, 0.0))
	_add_habitat_pad(open_perch, "OpenPerchPad", Color(0.36, 0.31, 0.23))
	var branch := MeshInstance3D.new()
	branch.name = "Perch_Branch_PresentationOnly"
	var branch_mesh := CylinderMesh.new()
	branch_mesh.top_radius = 0.11
	branch_mesh.bottom_radius = 0.15
	branch_mesh.height = 4.2
	branch.mesh = branch_mesh
	branch.position = Vector3(0.0, 0.55, 2.8)
	branch.rotation.z = PI * 0.5
	branch.material_override = _make_material(Color(0.31, 0.20, 0.12), 0.98)
	open_perch.add_child(branch)
	var post := MeshInstance3D.new()
	post.name = "Perch_Post_PresentationOnly"
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius = 0.10
	post_mesh.bottom_radius = 0.14
	post_mesh.height = 0.95
	post.mesh = post_mesh
	post.position = Vector3(0.0, 0.43, 2.8)
	post.material_override = _make_material(Color(0.28, 0.18, 0.11), 0.98)
	open_perch.add_child(post)
	add_child(_make_label("OPEN PERCH — PRESENTATION ONLY", Vector3(-4.0, 2.85, -5.4)))

	var rocky := _new_habitat_root("Habitat_RockyShelfPresentation", Vector3(12.0, 0.0, 0.0))
	_add_habitat_pad(rocky, "RockyShelfPad", Color(0.31, 0.32, 0.29))
	var rock_material := _make_material(Color(0.42, 0.43, 0.40), 0.94)
	for index in range(4):
		var rock := MeshInstance3D.new()
		rock.name = "Rock_%02d" % index
		var rock_mesh := SphereMesh.new()
		rock_mesh.radius = 0.5
		rock_mesh.height = 1.0
		rock.mesh = rock_mesh
		rock.scale = Vector3(1.2 + float(index % 2) * 0.35, 0.42, 0.78)
		rock.position = Vector3(-3.6 + float(index) * 2.3, 0.14, 2.6 + float(index % 2) * 0.8)
		rock.material_override = rock_material
		rocky.add_child(rock)
	add_child(_make_label("ROCKY SHELF — PRESENTATION ONLY", Vector3(8.0, 2.85, -5.4)))


func _build_mammal_study() -> void:
	var root := _new_specimen_root("GenericMammalStudy", Vector3(-12.0, 0.08, 0.0))
	var fur := _make_material(Color(0.48, 0.29, 0.16), 0.96)
	_add_ellipsoid(root, "Body_FurPlaceholder", Vector3(0.0, 1.0, 0.0), Vector3(1.25, 0.62, 0.58), fur)
	_add_ellipsoid(root, "Head_FurPlaceholder", Vector3(1.05, 1.35, 0.0), Vector3(0.48, 0.48, 0.42), fur)
	var mammal_legs: Array[MeshInstance3D] = []
	for x in [-0.78, 0.72]:
		for z in [-0.34, 0.34]:
			mammal_legs.append(_add_capsule(root, "Leg_FurPlaceholder", Vector3(x, 0.42, z), Vector3(0.18, 0.58, 0.18), fur))
	_moving_parts["mammal_legs"] = mammal_legs
	_add_capsule(root, "Tail_FurPlaceholder", Vector3(-1.35, 1.12, 0.0), Vector3(0.13, 0.58, 0.13), fur, Vector3(0.0, 0.0, -0.9))
	_specimens["mammal"] = root
	add_child(_make_label("GENERIC MAMMAL FORM — FUR MATERIAL STUDY", Vector3(-15.0, 2.45, -2.0)))


func _build_bird_study() -> void:
	var root := _new_specimen_root("GenericBirdStudy", Vector3(0.0, 0.08, 0.0))
	var feather := _make_material(Color(0.20, 0.38, 0.62), 0.78)
	var dark_feather := _make_material(Color(0.12, 0.22, 0.38), 0.82)
	_add_ellipsoid(root, "Body_FeatherPlaceholder", Vector3(0.0, 1.0, 0.0), Vector3(0.82, 0.62, 0.48), feather)
	_add_ellipsoid(root, "Head_FeatherPlaceholder", Vector3(0.68, 1.58, 0.0), Vector3(0.34, 0.36, 0.32), feather)
	_add_cone(root, "Beak_FeatherStudy", Vector3(1.02, 1.48, 0.0), Vector3(0.16, 0.42, 0.16), Color(0.82, 0.62, 0.24))
	var left_wing := _add_ellipsoid(root, "Wing_Left_FeatherPlaceholder", Vector3(-0.05, 1.14, -0.48), Vector3(0.62, 0.12, 0.34), dark_feather)
	var right_wing := _add_ellipsoid(root, "Wing_Right_FeatherPlaceholder", Vector3(-0.05, 1.14, 0.48), Vector3(0.62, 0.12, 0.34), dark_feather)
	_moving_parts["bird_wings"] = [left_wing, right_wing]
	var bird_legs: Array[MeshInstance3D] = []
	for side in [-1.0, 1.0]:
		var leg_index := bird_legs.size()
		bird_legs.append(_add_capsule(root, "Leg_BirdPlaceholder_%d" % leg_index, Vector3(0.04, 0.38, side * 0.16), Vector3(0.07, 0.28, 0.07), dark_feather))
	_moving_parts["bird_legs"] = bird_legs
	_specimens["bird"] = root
	add_child(_make_label("GENERIC BIRD FORM — FEATHER MATERIAL STUDY", Vector3(-3.0, 2.45, -2.0)))


func _build_reptile_study() -> void:
	var root := _new_specimen_root("GenericReptileStudy", Vector3(12.0, 0.08, 0.0))
	var scales := _make_material(Color(0.28, 0.43, 0.25), 0.48)
	scales.metallic = 0.04
	_add_ellipsoid(root, "Body_ScalePlaceholder", Vector3(0.0, 0.72, 0.0), Vector3(1.25, 0.38, 0.48), scales)
	_add_ellipsoid(root, "Head_ScalePlaceholder", Vector3(1.12, 0.82, 0.0), Vector3(0.48, 0.28, 0.32), scales)
	var reptile_tail := _add_capsule(root, "Tail_ScalePlaceholder", Vector3(-1.28, 0.66, 0.0), Vector3(0.16, 0.72, 0.16), scales, Vector3(0.0, 0.0, 1.0))
	_moving_parts["reptile_tail"] = [reptile_tail]
	var reptile_legs: Array[MeshInstance3D] = []
	for x in [-0.78, 0.72]:
		for z in [-0.34, 0.34]:
			reptile_legs.append(_add_capsule(root, "Leg_ScalePlaceholder", Vector3(x, 0.32, z), Vector3(0.13, 0.38, 0.13), scales))
	_moving_parts["reptile_legs"] = reptile_legs
	_specimens["reptile"] = root
	add_child(_make_label("GENERIC REPTILE FORM — SCALE MATERIAL STUDY", Vector3(8.5, 2.45, -2.0)))


func _new_specimen_root(root_name: String, root_position: Vector3) -> Node3D:
	var root := Node3D.new()
	root.name = root_name
	root.position = root_position
	_base_positions[root_name.replace("Generic", "").replace("Study", "").to_lower()] = root_position
	add_child(root)
	return root


func _is_locomoting(elapsed: float) -> bool:
	var phase := fposmod(elapsed, LOCOMOTION_LOOP_SECONDS)
	var second_travel_start := LOCOMOTION_TRAVEL_SECONDS + ENDPOINT_IDLE_SECONDS
	var second_travel_end := second_travel_start + LOCOMOTION_TRAVEL_SECONDS
	return phase < LOCOMOTION_TRAVEL_SECONDS or (phase >= second_travel_start and phase < second_travel_end)


func _motion_offset(elapsed: float, amplitude: float) -> float:
	var phase := fposmod(elapsed, LOCOMOTION_LOOP_SECONDS)
	var second_travel_start := LOCOMOTION_TRAVEL_SECONDS + ENDPOINT_IDLE_SECONDS
	var second_travel_end := second_travel_start + LOCOMOTION_TRAVEL_SECONDS
	if phase < LOCOMOTION_TRAVEL_SECONDS:
		return lerpf(-amplitude, amplitude, phase / LOCOMOTION_TRAVEL_SECONDS)
	if phase < second_travel_start:
		return amplitude
	if phase < second_travel_end:
		return lerpf(amplitude, -amplitude, (phase - second_travel_start) / LOCOMOTION_TRAVEL_SECONDS)
	return -amplitude


func _animate_leg_group(group_name: String, stride_phase: float, amplitude: float, moving: bool) -> void:
	var legs: Array = _moving_parts.get(group_name, [])
	for index in range(legs.size()):
		var leg := legs[index] as Node3D
		var phase_offset := 0.0 if index % 2 == 0 else PI
		leg.rotation.z = sin(stride_phase + phase_offset) * amplitude if moving else 0.0


func _animate_specimens() -> void:
	var moving := _is_locomoting(_elapsed)
	_animation_mode = "locomotion" if moving else "idle"
	var stride_phase := _elapsed * 5.5

	var mammal := _specimens.get("mammal") as Node3D
	if is_instance_valid(mammal):
		var mammal_base: Vector3 = _base_positions.get("mammal", Vector3.ZERO)
		mammal.position = mammal_base + Vector3(_motion_offset(_elapsed, 0.65), 0.025 + sin(_elapsed * 2.0) * 0.018, 0.0)
		mammal.rotation.y = sin(_elapsed * 0.55) * 0.05 if moving else 0.0
		_animate_leg_group("mammal_legs", stride_phase, 0.24, moving)

	var bird := _specimens.get("bird") as Node3D
	if is_instance_valid(bird):
		var bird_base: Vector3 = _base_positions.get("bird", Vector3.ZERO)
		var hop := maxf(sin(stride_phase), 0.0) * 0.045 if moving else 0.0
		bird.position = bird_base + Vector3(_motion_offset(_elapsed, 0.45), 0.025 + sin(_elapsed * 2.8) * 0.025 + hop, 0.0)
		bird.rotation.y = sin(_elapsed * 0.65) * 0.06 if moving else 0.0
		var wings: Array = _moving_parts.get("bird_wings", [])
		for index in range(wings.size()):
			var wing := wings[index] as Node3D
			var side := -1.0 if index == 0 else 1.0
			wing.rotation.z = sin(_elapsed * 4.0) * 0.18 * side if moving else sin(_elapsed * 1.4) * 0.025 * side
		_animate_leg_group("bird_legs", stride_phase, 0.13, moving)

	var reptile := _specimens.get("reptile") as Node3D
	if is_instance_valid(reptile):
		var reptile_base: Vector3 = _base_positions.get("reptile", Vector3.ZERO)
		reptile.position = reptile_base + Vector3(_motion_offset(_elapsed, 0.34), 0.012 + sin(_elapsed * 1.2) * 0.01, 0.0)
		reptile.rotation.y = sin(_elapsed * 1.5) * 0.05 if moving else sin(_elapsed * 0.5) * 0.01
		_animate_leg_group("reptile_legs", stride_phase * 0.65, 0.11, moving)
		var tails: Array = _moving_parts.get("reptile_tail", [])
		for tail in tails:
			(tail as Node3D).rotation.y = sin(_elapsed * 1.6) * 0.12


func _add_ellipsoid(parent: Node3D, part_name: String, part_position: Vector3, part_scale: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = part_name
	var mesh := SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.0
	instance.mesh = mesh
	instance.position = part_position
	instance.scale = part_scale
	instance.material_override = material
	parent.add_child(instance)
	return instance


func _add_capsule(parent: Node3D, part_name: String, part_position: Vector3, part_scale: Vector3, material: StandardMaterial3D, rotation: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = part_name
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.8
	instance.mesh = mesh
	instance.position = part_position
	instance.scale = part_scale
	instance.rotation = rotation
	instance.material_override = material
	parent.add_child(instance)
	return instance


func _add_cone(parent: Node3D, part_name: String, part_position: Vector3, part_scale: Vector3, color: Color) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = part_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.0
	mesh.bottom_radius = 0.5
	mesh.height = 1.0
	instance.mesh = mesh
	instance.position = part_position
	instance.scale = part_scale
	instance.rotation.z = -PI * 0.5
	instance.material_override = _make_material(color, 0.72)
	parent.add_child(instance)
	return instance


func _make_material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material


func _make_label(value: String, label_position: Vector3) -> Label3D:
	var label := Label3D.new()
	label.text = value
	label.position = label_position
	label.font_size = 28
	label.modulate = Color(0.94, 0.95, 0.92)
	return label


func update_visual_lod_for_camera(camera_position: Vector3) -> Dictionary:
	for specimen_name: String in _specimens.keys():
		var specimen := _specimens[specimen_name] as Node3D
		var distance := camera_position.distance_to(specimen.global_position)
		var tier: String = VisualLOD.classify_distance(distance)
		if tier.is_empty():
			continue
		_visual_lod_tiers[specimen_name] = tier
		_apply_visual_lod(specimen, tier)
	return _visual_lod_tiers.duplicate()


func _apply_visual_lod(specimen: Node3D, tier: String) -> void:
	specimen.visible = tier != VisualLOD.OFF
	specimen.set_meta("visual_lod_tier", tier)
	for child in specimen.get_children():
		if not (child is MeshInstance3D):
			continue
		var part_name := child.name
		var limb_detail := part_name.begins_with("Leg_") or part_name.begins_with("Tail_")
		var fine_detail := part_name.begins_with("Wing_") or part_name.begins_with("Beak_")
		if tier == VisualLOD.MID:
			child.visible = not limb_detail
		elif tier == VisualLOD.FAR:
			child.visible = not (limb_detail or fine_detail)
		else:
			child.visible = true


func get_visual_prototype_state() -> Dictionary:
	var moving_part_total := 0
	for part_group in _moving_parts.values():
		if part_group is Array:
			moving_part_total += part_group.size()
	return {
		"prototype_count": _specimens.size(),
		"prototype_names": _specimens.keys(),
		"moving_part_count": moving_part_total,
		"elapsed_seconds": _elapsed,
		"animation_mode": _animation_mode,
		"habitat_presentation_count": _habitat_roots.size(),
		"habitat_evidence_status": "presentation-only; not species occurrence evidence",
		"habitat_species_evidence": false,
		"visual_lod_tiers": _visual_lod_tiers.duplicate(),
		"production_assets": false,
		"species_assignments": false,
		"nonviolent_visual_only": true,
	}
