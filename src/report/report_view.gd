extends VBoxContainer

@onready var interval_picker: IntervalPicker = %IntervalPicker
@onready var report: Report = %Report
@onready var day_selector: DaySelector = %DaySelector
@onready var total_label: Label = %TotalLabel
@onready var total_check_button: CheckButton = %TotalCheckButton
@onready var interval_control_container: HBoxContainer = %IntervalControlContainer


func _on_display_interval_button_pressed() -> void:
	interval_picker.visible = not interval_picker.visible


func _on_interval_picker_new_interval(start: Date, end: Date) -> void:
	report.set_interval(start, end)
	day_selector.set_interval(start, end)
	interval_control_container.show()
	total_check_button.set_pressed_no_signal(false)
	total_label.hide()
	day_selector.show()


func _on_day_selector_new_day(_old_day: Date, new_day: Date) -> void:
	report.open_new_day(new_day)


func _on_total_check_button_toggled(toggled_on: bool) -> void:
	report.total_toggled = toggled_on
	if toggled_on:
		total_label.show()
		day_selector.hide()
	else:
		total_label.hide()
		day_selector.show()


func _on_interval_reset_button_pressed() -> void:
	interval_picker.clear_interval()
	interval_control_container.hide()
	total_label.hide()
	day_selector.show()


func _on_interval_picker_reset_interval() -> void:
	report.clear_interval()
	day_selector.clear_interval()