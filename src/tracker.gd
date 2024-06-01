extends Node2D

func _ready() -> void:
	if(OS.has_feature("window_decoration")):
		get_window().borderless = false
