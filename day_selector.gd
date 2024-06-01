extends HBoxContainer

@onready var selected_day: Dictionary = SelectedDay.selected_day.duplicate()
@onready var days_in_month: Array[int] = _get_days_in_month()

func _process(_delta: float) -> void:
	$DateLabel.text = "%s.%s.%s" % [selected_day["day"], selected_day["month"], selected_day["year"]]

func _on_previous_day_button_pressed() -> void:
	selected_day["weekday"] = (selected_day["weekday"] + 1) % 7
	selected_day["day"] -= 1
	if selected_day["day"] == 0:
		selected_day["month"] -= 1
		if selected_day["month"] == 0:
			selected_day["month"] = 12
			selected_day["year"] -= 1
		selected_day["day"] = days_in_month[selected_day["month"] - 1]
	SelectedDay.selected_day = selected_day.duplicate()

func _on_next_day_button_pressed() -> void:
	selected_day["weekday"] = (selected_day["weekday"] + 1) % 7
	selected_day["day"] += 1
	if selected_day["day"] > days_in_month[selected_day["month"] - 1]:
		selected_day["day"] = 1
		selected_day["month"] += 1
		if selected_day["month"] > 12:
			selected_day["month"] = 1
			selected_day["year"] += 1
	SelectedDay.selected_day = selected_day.duplicate()

func _get_days_in_month() -> Array[int]:
	var datetime = Time.get_datetime_dict_from_system(true)
	var days: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if datetime["year"] % 4 == 0 and (datetime["year"] % 100 != 0 or datetime["year"] % 400 == 0):
		days[1] = 29
	return days
