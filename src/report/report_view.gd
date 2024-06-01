extends VBoxContainer

@onready var interval_picker: HBoxContainer = %IntervalPicker
@onready var report: Report = %Report
@onready var day_selector: DaySelector = %DaySelector


func _on_display_interval_button_pressed() -> void:
	interval_picker.visible = not interval_picker.visible


func _on_interval_picker_new_interval(start: Date, end: Date) -> void:
	report.set_interval(start, end)
	day_selector.set_interval(start, end)


func _on_day_selector_new_day(_old_day: Date, new_day: Date) -> void:
	report.open_new_day(new_day)
