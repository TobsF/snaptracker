extends Node2D
class_name CompactView

signal return_to_large_view()

func _ready() -> void:
	get_window().size = %TrackingLabel.size
	for activity: Activity in get_tree().get_nodes_in_group("activity_tracking"):
		if activity.is_active():
			%TrackingLabel.text = activity.get_activity_name()

func _on_texture_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_window().borderless = true
		get_window().always_on_top = true
		%UnfoldButton.visible = false
	else:
		%UnfoldButton.visible = true
		get_window().borderless = false
		get_window().always_on_top = false

func _on_unfold_button_pressed() -> void:
	return_to_large_view.emit()
