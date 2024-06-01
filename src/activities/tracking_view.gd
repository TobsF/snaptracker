extends VBoxContainer
class_name TrackingView

signal to_compact_view()




func _on_fold_button_pressed() -> void:
	to_compact_view.emit()
