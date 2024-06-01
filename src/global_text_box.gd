extends Node2D

@export var label_size: Vector2i = Vector2i(300, 100)
@export var margin: Vector2i = Vector2i(15, 15)

@onready var label: Label = %Label

func _ready() -> void:
	%Label.size = label_size
	global_position = get_window().size - label_size - margin
	GlobalTextTopic.new_text.connect(_on_new_text)
	GlobalTextTopic.new_temporary_notification.connect(_on_new_temporary_notification)

func _on_new_text(text: String) -> void:
	if %Timer.time_left > 0:
		await %Timer.timeout
	label.text = text

func _on_new_temporary_notification(text: String, display_time: int, restore_previous: bool) -> void:
	if %Timer.time_left > 0:
		await %Timer.timeout
	var old_text: String = label.text
	label.text = text
	
	%Timer.start(display_time)
	await %Timer.timeout
	
	if restore_previous:
		label.text = old_text
	else:
		label.text = ""
