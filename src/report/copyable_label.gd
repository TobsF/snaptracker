extends Label
class_name CopyableLabel

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var clickable_area: Area2D = $ClickableArea

func _process(_delta: float) -> void:
	collision_shape_2d.shape.size = size
	collision_shape_2d.position = collision_shape_2d.shape.size / 2
	

func _on_clickable_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		DisplayServer.clipboard_set(text)
		GlobalTextTopic.new_temporary_notification.emit("Copied!", 1, false)


func _on_clickable_area_mouse_entered() -> void:
	GlobalTextTopic.new_text.emit("Leftclick to copy")


func _on_clickable_area_mouse_exited() -> void:
	GlobalTextTopic.new_text.emit("")
