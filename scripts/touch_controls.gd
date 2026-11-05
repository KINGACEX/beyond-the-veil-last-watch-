extends Control

## Touch buttons feed the same InputMap actions as keyboard controls.

const ACTIONS: Array[StringName] = [&"move_forward", &"move_back", &"move_left", &"move_right", &"interact"]

@onready var _forward: Button = $MovePad/Forward
@onready var _back: Button = $MovePad/Back
@onready var _left: Button = $MovePad/Left
@onready var _right: Button = $MovePad/Right
@onready var _interact: Button = $Interact

var _pressed_actions: Dictionary = {}


func _ready() -> void:
	visible = DisplayServer.is_touchscreen_available()
	_bind_action(_forward, &"move_forward")
	_bind_action(_back, &"move_back")
	_bind_action(_left, &"move_left")
	_bind_action(_right, &"move_right")
	_bind_action(_interact, &"interact")


func _bind_action(button: Button, action_name: StringName) -> void:
	button.button_down.connect(_press_action.bind(action_name))
	button.button_up.connect(_release_action.bind(action_name))


func _press_action(action_name: StringName) -> void:
	if _pressed_actions.has(action_name):
		return
	_pressed_actions[action_name] = true
	Input.action_press(action_name)


func _release_action(action_name: StringName) -> void:
	_pressed_actions.erase(action_name)
	Input.action_release(action_name)


func _release_all_actions() -> void:
	for action_name in ACTIONS:
		Input.action_release(action_name)
	_pressed_actions.clear()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		_release_all_actions()


func _exit_tree() -> void:
	_release_all_actions()
