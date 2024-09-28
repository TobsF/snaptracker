extends Label
class_name CopyableLabel

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		DisplayServer.clipboard_set(text)
		GlobalTextTopic.new_temporary_notification.emit("Copied!", 1, false)

func _on_mouse_entered() -> void:
	GlobalTextTopic.new_text.emit("Left-click to copy")

func _on_mouse_exited() -> void:
	GlobalTextTopic.new_text.emit("")
