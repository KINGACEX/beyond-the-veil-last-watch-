extends Node3D
class_name BTVCharacterVisuals

## Procedural, low-poly character presentation for the first playable prototype.
## This is a temporary authored mock character, not a final canon-locked character model.

@export_enum("asher", "ridgeview_resident") var character_style: String = "asher"

var _elapsed := 0.0
var _body_root: Node3D


func _ready() -> void:
	_build_character()


func _process(delta: float) -> void:
	_elapsed += delta
	if is_instance_valid(_body_root):
		_body_root.position.y = sin(_elapsed * 2.0) * 0.018


func _build_character() -> void:
	_body_root = Node3D.new()
	_body_root.name = "CharacterModel"
	add_child(_body_root)

	var asher := character_style == "asher"
	var coat := _material(Color("#263d55") if asher else Color("#6b5540"))
	var shirt := _material(Color("#d8d1bd") if asher else Color("#c6b18b"))
	var trousers := _material(Color("#30333b") if asher else Color("#4b5145"))
	var skin := _material(Color("#8a563c"))
	var hair := _material(Color("#211d1b"))
	var boots := _material(Color("#211f20"))
	var trim := _material(Color("#bd985d") if asher else Color("#8d9b82"))

	_part("Torso", CapsuleMesh.new(), Vector3(0, 1.16, 0), Vector3(0.48, 0.68, 0.30), coat)
	_part("ShirtFront", BoxMesh.new(), Vector3(0, 1.20, -0.158), Vector3(0.19, 0.46, 0.025), shirt)
	_part("Belt", BoxMesh.new(), Vector3(0, 0.83, 0), Vector3(0.43, 0.075, 0.31), boots)
	_part("BeltBuckle", BoxMesh.new(), Vector3(0, 0.83, -0.17), Vector3(0.075, 0.07, 0.025), trim)

	_part("Neck", CylinderMesh.new(), Vector3(0, 1.57, 0), Vector3(0.13, 0.16, 0.13), skin)
	_part("Head", SphereMesh.new(), Vector3(0, 1.78, 0), Vector3(0.29, 0.36, 0.27), skin)
	_part("Hair", SphereMesh.new(), Vector3(0, 1.96, 0.015), Vector3(0.30, 0.20, 0.28), hair)
	_part("HairFringe", BoxMesh.new(), Vector3(0, 1.91, -0.22), Vector3(0.32, 0.10, 0.10), hair)
	_part("EyeLeft", SphereMesh.new(), Vector3(-0.095, 1.80, -0.245), Vector3(0.035, 0.035, 0.018), boots)
	_part("EyeRight", SphereMesh.new(), Vector3(0.095, 1.80, -0.245), Vector3(0.035, 0.035, 0.018), boots)

	_limb("ArmLeft", Vector3(-0.32, 1.20, 0), Vector3(0.13, 0.48, 0.13), coat, -0.10)
	_limb("ArmRight", Vector3(0.32, 1.20, 0), Vector3(0.13, 0.48, 0.13), coat, 0.10)
	_part("HandLeft", SphereMesh.new(), Vector3(-0.36, 0.91, -0.01), Vector3(0.10, 0.12, 0.10), skin)
	_part("HandRight", SphereMesh.new(), Vector3(0.36, 0.91, -0.01), Vector3(0.10, 0.12, 0.10), skin)

	_limb("LegLeft", Vector3(-0.13, 0.47, 0), Vector3(0.17, 0.55, 0.18), trousers)
	_limb("LegRight", Vector3(0.13, 0.47, 0), Vector3(0.17, 0.55, 0.18), trousers)
	_part("BootLeft", BoxMesh.new(), Vector3(-0.13, 0.13, -0.045), Vector3(0.19, 0.22, 0.32), boots)
	_part("BootRight", BoxMesh.new(), Vector3(0.13, 0.13, -0.045), Vector3(0.19, 0.22, 0.32), boots)

	if asher:
		_part("ShoulderTrim", BoxMesh.new(), Vector3(0, 1.48, -0.16), Vector3(0.30, 0.045, 0.025), trim)
		_part("TravelStrap", BoxMesh.new(), Vector3(0.19, 1.25, -0.17), Vector3(0.065, 0.64, 0.035), boots)
		_part("Satchel", BoxMesh.new(), Vector3(0.30, 0.92, 0.16), Vector3(0.22, 0.25, 0.12), trim)
	else:
		_part("Scarf", BoxMesh.new(), Vector3(0, 1.51, -0.17), Vector3(0.34, 0.09, 0.06), trim)


func _limb(part_name: String, part_position: Vector3, part_scale: Vector3, material: Material, tilt: float = 0.0) -> void:
	var mesh := CapsuleMesh.new()
	mesh.radius = part_scale.x
	mesh.height = part_scale.y
	_part(part_name, mesh, part_position, Vector3.ONE, material, Vector3(0, 0, tilt))


func _part(part_name: String, mesh: PrimitiveMesh, part_position: Vector3, part_scale: Vector3, material: Material, part_rotation: Vector3 = Vector3.ZERO) -> void:
	var instance := MeshInstance3D.new()
	instance.name = part_name
	instance.mesh = mesh
	instance.position = part_position
	instance.scale = part_scale
	instance.rotation = part_rotation
	instance.material_override = material
	_body_root.add_child(instance)


func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.82
	return material
