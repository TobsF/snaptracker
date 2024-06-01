extends Node

var selected_day: Date

func _ready() -> void:
	selected_day = Date.current_as_date()
