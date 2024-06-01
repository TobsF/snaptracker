extends VBoxContainer

@onready var interval_picker: HBoxContainer = %IntervalPicker


func _on_display_interval_button_pressed() -> void:
	interval_picker.visible = not interval_picker.visible


func _on_interval_picker_new_interval(start: Date, end: Date) -> void:
	pass # Replace with function body.
