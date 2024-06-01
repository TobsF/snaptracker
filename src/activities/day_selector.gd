extends HBoxContainer

signal new_day(old_day: Date, new_day: Date)

@onready var selected_day: Date = SelectedDay.selected_day.duplicated()
@onready var days_in_month: Array[int] = _get_days_in_month()

func _process(_delta: float) -> void:
	$DateLabel.text = "%s.%s.%s" % [selected_day.day, selected_day.month, selected_day.year]

func _on_previous_day_button_pressed() -> void:
	var next_day: int = selected_day.weekday - 1
	if next_day < 0:
		next_day = 6
	selected_day.weekday = next_day
	selected_day.day -= 1
	if selected_day.day == 0:
		selected_day.month -= 1
		if selected_day.month == 0:
			selected_day.month = 12
			selected_day.year -= 1
		selected_day.day = days_in_month[selected_day.month - 1]
	new_day.emit(SelectedDay.selected_day, selected_day.duplicated())
	SelectedDay.selected_day = selected_day.duplicated()

func _on_next_day_button_pressed() -> void:
	selected_day.weekday = (selected_day.weekday + 1) % 7
	selected_day.day += 1
	if selected_day.day > days_in_month[selected_day.month - 1]:
		selected_day.day = 1
		selected_day.month += 1
		if selected_day.month > 12:
			selected_day.month = 1
			selected_day.year += 1
	new_day.emit(SelectedDay.selected_day, selected_day.duplicated())
	SelectedDay.selected_day = selected_day.duplicated()

func _get_days_in_month() -> Array[int]:
	return Date.get_days_in_month()
