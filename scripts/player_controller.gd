extends CharacterBody3D
class_name BTVPlayerController

## Minimal third-person greybox controller.
## Keyboard input is for the first desktop smoke test; touch controls are a later gate.

@export_range(0.5, 12.0, 0.1) var move_speed: float = 4.0
@export_range(0.0, 30.0, 0.1) var turn_speed: float = 12.0

var _gravity: float = 9.8


func _ready() -> void:
	_gravity = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)
	var move_direction := Vector3(input_vector.x, 0.0, input_vector.y).normalized()

	if not is_on_floor():
		velocity.y -= _gravity * delta
	else:
		velocity.y = 0.0

	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

	if move_direction.length_squared() > 0.001:
		var target_yaw := atan2(-move_direction.x, -move_direction.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, min(turn_speed * delta, 1.0))

	move_and_slide()
