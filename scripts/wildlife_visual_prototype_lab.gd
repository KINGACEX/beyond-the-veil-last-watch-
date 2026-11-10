extends Node3D
## Isolated wildlife visual study. All forms are generic placeholders, not species assets.
## No species placement, navigation, hunting, capture or combat is implemented.

@onready var _telemetry: Label = $HUD/Telemetry

var _elapsed := 0.0
var _specimens: Dictionary = {}
var _moving_parts: Dictionary = {}


func _ready() -> void:
	_build_floor()
	_build_mammal_study()
	_build_bird_study()
	_build_reptile_study()
	_update_telemetry()


func _process(delta: float) -> void:
	_elapsed += maxf(delta, 0.0)
	if _specimens.has("mammal"):
		(_specimens["mammal"] as Node3D).position.y = 0.08 + sin(_elapsed * 2.0) * 0.045
	if _specimens.has("bird"):
		(_specimens["bird"] as Node3D).position.y = 0.08 + sin(_elapsed * 2.8) * 0.055
	if _moving_parts.has("bird_wings"):
		var wings: Array = _moving_parts["bird_wings"]
		for index in range(wings.size()):
			var wing := wings[index] as Node3D
			var side := -1.0 if index == 0 else 1.0
			wing.rotation.z = sin(_elapsed * 3.2) * 0.10 * side
	if _specimens.has("reptile"):
		(_specimens["reptile"] as Node3D).position.y = 0.08 + sin(_elapsed * 1.2) * 0.018


func _update_telemetry() -> void:
	_telemetry.text = (
		"WILDLIFE VISUAL PROTOTYPE LAB — GENERIC PLACEHOLDERS\n"
		+ "Three broad body-form studies: mammal | bird | reptile\n"
		+ "Surface studies: rough fur-like, feather-like and scale-like materials\n"
		+ "Simple idle motion only; no rigged locomotion, textures or species identity\n"
		+ "These are generic placeholders, not production wildlife assets."
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


func _build_mammal_study() -> void:
	var root := _new_specimen_root("GenericMammalStudy", Vector3(-12.0, 0.08, 0.0))
	var fur := _make_material(Color(0.48, 0.29, 0.16), 0.96)
	_add_ellipsoid(root, "Body_FurPlaceholder", Vector3(0.0, 1.0, 0.0), Vector3(1.25, 0.62, 0.58), fur)
	_add_ellipsoid(root, "Head_FurPlaceholder", Vector3(1.05, 1.35, 0.0), Vector3(0.48, 0.48, 0.42), fur)
	for x in [-0.78, 0.72]:
		for z in [-0.34, 0.34]:
			_add_capsule(root, "Leg_FurPlaceholder", Vector3(x, 0.42, z), Vector3(0.18, 0.58, 0.18), fur)
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
	_specimens["bird"] = root
	add_child(_make_label("GENERIC BIRD FORM — FEATHER MATERIAL STUDY", Vector3(-3.0, 2.45, -2.0)))


func _build_reptile_study() -> void:
	var root := _new_specimen_root("GenericReptileStudy", Vector3(12.0, 0.08, 0.0))
	var scales := _make_material(Color(0.28, 0.43, 0.25), 0.48)
	scales.metallic = 0.04
	_add_ellipsoid(root, "Body_ScalePlaceholder", Vector3(0.0, 0.72, 0.0), Vector3(1.25, 0.38, 0.48), scales)
	_add_ellipsoid(root, "Head_ScalePlaceholder", Vector3(1.12, 0.82, 0.0), Vector3(0.48, 0.28, 0.32), scales)
	_add_capsule(root, "Tail_ScalePlaceholder", Vector3(-1.28, 0.66, 0.0), Vector3(0.16, 0.72, 0.16), scales, Vector3(0.0, 0.0, 1.0))
	for x in [-0.78, 0.72]:
		for z in [-0.34, 0.34]:
			_add_capsule(root, "Leg_ScalePlaceholder", Vector3(x, 0.32, z), Vector3(0.13, 0.38, 0.13), scales)
	_specimens["reptile"] = root
	add_child(_make_label("GENERIC REPTILE FORM — SCALE MATERIAL STUDY", Vector3(8.5, 2.45, -2.0)))


func _new_specimen_root(root_name: String, root_position: Vector3) -> Node3D:
	var root := Node3D.new()
	root.name = root_name
	root.position = root_position
	add_child(root)
	return root


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


func get_visual_prototype_state() -> Dictionary:
	return {
		"prototype_count": _specimens.size(),
		"prototype_names": _specimens.keys(),
		"moving_part_count": (_moving_parts.get("bird_wings", []) as Array).size(),
		"elapsed_seconds": _elapsed,
		"production_assets": false,
		"species_assignments": false,
	}
