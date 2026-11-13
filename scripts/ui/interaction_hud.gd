extends CanvasLayer
class_name BTVInteractionHUD

@onready var _prompt_panel: PanelContainer = $SafeArea/PromptPanel
@onready var _prompt_label: Label = $SafeArea/PromptPanel/PromptLabel
@onready var _feedback_panel: PanelContainer = $SafeArea/FeedbackPanel
@onready var _feedback_label: Label = $SafeArea/FeedbackPanel/FeedbackLabel

var _bound_player: BTVPlayerController = null


func _ready() -> void:
	_prompt_panel.visible = false
	_feedback_panel.visible = false
	_bind_player()
	if _bound_player == null:
		set_process(true)
	else:
		set_process(false)


func _process(_delta: float) -> void:
	if _bound_player == null:
		_bind_player()
		if _bound_player != null:
			set_process(false)


func _bind_player() -> void:
	var candidate := get_tree().get_first_node_in_group("btv_player") as BTVPlayerController
	if candidate == null:
		return
	_bound_player = candidate
	if not candidate.interaction_target_changed.is_connected(_on_interaction_target_changed):
		candidate.interaction_target_changed.connect(_on_interaction_target_changed)
	if not candidate.interaction_feedback.is_connected(_on_interaction_feedback):
		candidate.interaction_feedback.connect(_on_interaction_feedback)


func _on_interaction_target_changed(prompt: String) -> void:
	_prompt_panel.visible = not prompt.is_empty()
	if prompt.is_empty():
		_prompt_label.text = ""
		return
	var input_hint := "Tap Interact" if DisplayServer.is_touchscreen_available() else "E"
	_prompt_label.text = input_hint + "  ·  " + prompt


func _on_interaction_feedback(message: String) -> void:
	_feedback_panel.visible = not message.is_empty()
	_feedback_label.text = message


func is_prompt_visible() -> bool:
	return _prompt_panel.visible


func is_feedback_visible() -> bool:
	return _feedback_panel.visible


func get_prompt_text() -> String:
	return _prompt_label.text


func get_feedback_text() -> String:
	return _feedback_label.text
