extends Node

func _process(_delta: float) -> void:
	if get_parent() is Control:
		get_parent().size = get_window().size
	else:
		get_parent().scale = get_window().size
 
