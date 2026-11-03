extends Control

## Minimal touch overlay for the greybox prototype.
## Buttons feed the same InputMap actions used by the desktop controller.

@onready var _forward: Button = $MovePad/Forward
@onready var _back: Button = $MovePad/Back
@onready var _left: Button = $MovePad/Left
@onready var _right: Button = $MovePad/Right
@onready var _interact: Button = $Interact


func _ready() -> void:
	visible = DisplayServer.is_touchscreen_available()
	_bind_action(_forward, "move_forward")
	_bind_action(_back, "move_back")
	_bind_action(_left, "move_left")
	_bind_action(_right, "move_right")
	_bind_action(_interact, "interact")


func _bind_action(button: Button, action_name: StringName) -> void:
	button.button_down.connect(_press_action.bind(action_name))
	button.button_up.connect(_release_action.bind(action_name))


func _press_action(action_name: StringName) -> void:
	Input.action_press(action_name)


func _release_action(action_name: StringName) -> void:
	Input.action_release(action_name)


func _exit_tree() -> void:
	for action_name in [&"move_forward", &"move_back", &"move_left", &"move_right", &"interact"]:
		Input.action_release(action_name)
