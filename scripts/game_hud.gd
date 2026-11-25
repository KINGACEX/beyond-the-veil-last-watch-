extends CanvasLayer
class_name BTVGameHUD

@onready var _message: Label = $Root/MessagePanel/Message


func _ready() -> void:
	var player := get_parent().get_node_or_null("Player")
	if player != null and player.has_signal("interaction_feedback"):
		player.interaction_feedback.connect(_on_interaction_feedback)


func _on_interaction_feedback(message: String) -> void:
	_message.text = message
