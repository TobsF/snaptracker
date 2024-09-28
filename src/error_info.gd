extends MarginContainer
class_name ErrorInfo

static var SCENE: PackedScene = preload("res://src/error_info.tscn")

@export var error_text: String = "An unexpected error occured."
@onready var error_text_label: Label = %ErrorTextLabel


func _ready() -> void:
	error_text_label.text = error_text

func _on_remove_button_pressed() -> void:
	queue_free()
