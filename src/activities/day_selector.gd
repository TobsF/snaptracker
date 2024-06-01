extends HBoxContainer

signal new_day(old_day: Date, new_day: Date)

@onready var selected_day: Date = SelectedDay.selected_day.duplicated()
@onready var days_in_month: Array[int] = _get_days_in_month()
@export var interval_start: Date
@export var interval_end: Date

func _process(_delta: float) -> void:
	$DateLabel.text = "%s.%s.%s" % [selected_day.day, selected_day.month, selected_day.year]

func _on_previous_day_button_pressed() -> void:
	selected_day = Date.get_previous(selected_day)
	new_day.emit(SelectedDay.selected_day, selected_day.duplicated())
	SelectedDay.selected_day = selected_day.duplicated()
	
	%NextDayButton.show()
	if interval_start and selected_day.compare(interval_start) <= 0:
		%PreviousDayButton.hide()
		

func _on_next_day_button_pressed() -> void:
	selected_day = Date.get_next(selected_day)
	new_day.emit(SelectedDay.selected_day, selected_day.duplicated())
	SelectedDay.selected_day = selected_day.duplicated()
	
	%PreviousDayButton.show()
	if interval_end and selected_day.compare(interval_end) >= 0:
		%NextDayButton.hide()

func _get_days_in_month() -> Array[int]:
	return Date.get_days_in_month()
