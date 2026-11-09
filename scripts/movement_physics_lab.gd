extends Node3D
## Neutral, canon-free course for measuring player movement, collision and camera behaviour.
## All geometry is temporary greybox test equipment; no Ridgeview production art is present.

@onready var _player: BTVPlayerController = $Player
@onready var _telemetry: Label = $HUD/Telemetry

var _floor_material: StandardMaterial3D
var _obstacle_material: StandardMaterial3D
var _ramp_material: StandardMaterial3D
var _marker_material: StandardMaterial3D


func _ready() -> void:
	_floor_material = _make_material(Color(0.34, 0.36, 0.38))
	_obstacle_material = _make_material(Color(0.48, 0.50, 0.52))
	_ramp_material = _make_material(Color(0.40, 0.43, 0.46))
	_marker_material = _make_material(Color(0.72, 0.74, 0.76))
	_build_course()


func _process(_delta: float) -> void:
	if not is_instance_valid(_player) or not is_instance_valid(_telemetry):
		return
	var velocity := _player.velocity
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	var input_vector: Vector2 = _player.call("_get_composed_movement_input")
	var camera_pivot: Node3D = _player.get_node("CameraPivot")
	var pitch_degrees := rad_to_deg(camera_pivot.rotation.x)
	var floor_text := "airborne"
	if _player.is_on_floor():
		floor_text = "grounded / %.1f deg" % rad_to_deg(_player.get_floor_angle())
	_telemetry.text = (
		"NEUTRAL MOVEMENT + PHYSICS LAB\n"
		+ "Speed: %.2f m/s   Velocity: (%.2f, %.2f, %.2f)\n" % [horizontal_speed, velocity.x, velocity.y, velocity.z]
		+ "Input: (%.2f, %.2f)   State: %s\n" % [input_vector.x, input_vector.y, floor_text]
		+ "Camera pitch: %.1f deg\n" % pitch_degrees
		+ "Accel: %.1f m/s²   Brake: %.1f m/s²\n" % [_player.ground_acceleration, _player.ground_deceleration]
		+ "Course: flat lane | ramps | steps | walls | corners | doorway\n"
		+ "Use movement + look together. Test start, stop, turn and collision response."
	)


func _make_material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	return material


func _build_course() -> void:
	var course := Node3D.new()
	course.name = "Course"
	add_child(course)

	_add_box(course, "Ground", Vector3(0, -0.5, 0), Vector3(64, 1, 64), _floor_material)

	# Flat acceleration / braking lane with simple non-colliding distance marks.
	for index in range(-3, 4):
		_add_marker(course, "LaneMark_%d" % index, Vector3(float(index) * 2.0, 0.015, 12), Vector3(0.06, 0.02, 18))
	_add_marker(course, "LaneStart", Vector3(-7, 0.02, 12), Vector3(0.12, 0.025, 18))
	_add_marker(course, "LaneFinish", Vector3(7, 0.02, 12), Vector3(0.12, 0.025, 18))

	# Two measured ramp angles; the player approaches from negative Z.
	_add_box(course, "Ramp_Gentle", Vector3(-15, 0.24, -7), Vector3(8, 0.4, 5), _ramp_material, Vector3(10, 0, 0))
	_add_box(course, "Ramp_Steeper", Vector3(-15, 0.72, 3), Vector3(8, 0.4, 5), _ramp_material, Vector3(20, 0, 0))

	# Three low steps with distinct top heights; no automatic step-up code is added.
	_add_box(course, "Step_01", Vector3(-15, 0.12, 10), Vector3(3.0, 0.24, 0.8), _obstacle_material)
	_add_box(course, "Step_02", Vector3(-15, 0.32, 10.8), Vector3(3.0, 0.64, 0.8), _obstacle_material)
	_add_box(course, "Step_03", Vector3(-15, 0.52, 11.6), Vector3(3.0, 1.04, 0.8), _obstacle_material)

	# Isolated wall and collision corner.
	_add_box(course, "Wall_Front", Vector3(0, 1.0, -11), Vector3(7, 2, 0.35), _obstacle_material)
	_add_box(course, "Corner_Wall_A", Vector3(13, 1.0, -11), Vector3(5, 2, 0.35), _obstacle_material)
	_add_box(course, "Corner_Wall_B", Vector3(15.3, 1.0, -8.5), Vector3(0.35, 2, 5), _obstacle_material)

	# A 1.4 m clear opening and a parallel-wall corridor for clearance testing.
	_add_box(course, "Doorway_Left", Vector3(7.0, 1.0, -11), Vector3(1.5, 2, 0.35), _obstacle_material)
	_add_box(course, "Doorway_Right", Vector3(9.9, 1.0, -11), Vector3(1.5, 2, 0.35), _obstacle_material)
	_add_box(course, "Corridor_Left", Vector3(7.0, 1.0, 10), Vector3(0.35, 2, 9), _obstacle_material)
	_add_box(course, "Corridor_Right", Vector3(9.1, 1.0, 10), Vector3(0.35, 2, 9), _obstacle_material)

	# Camera obstruction test wall behind the default player start.
	_add_box(course, "Camera_Occlusion_Wall", Vector3(0, 1.6, 7), Vector3(9, 3.2, 0.35), _obstacle_material)


func _add_box(
	parent: Node3D,
	box_name: String,
	box_position: Vector3,
	box_size: Vector3,
	material: StandardMaterial3D,
	box_rotation_degrees: Vector3 = Vector3.ZERO,
) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = box_name
	body.position = box_position
	body.rotation_degrees = box_rotation_degrees
	parent.add_child(body)

	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = box_size
	collision.shape = shape
	body.add_child(collision)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "MeshInstance3D"
	var mesh := BoxMesh.new()
	mesh.size = box_size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	return body


func _add_marker(parent: Node3D, marker_name: String, marker_position: Vector3, marker_size: Vector3) -> void:
	var marker := MeshInstance3D.new()
	marker.name = marker_name
	marker.position = marker_position
	var mesh := BoxMesh.new()
	mesh.size = marker_size
	marker.mesh = mesh
	marker.material_override = _marker_material
	parent.add_child(marker)
