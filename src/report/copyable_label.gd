extends Label
class_name CopyableLabel

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func _process(_delta: float) -> void:
	collision_shape_2d.shape.size = size 


func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		DisplayServer.clipboard_set(text)
