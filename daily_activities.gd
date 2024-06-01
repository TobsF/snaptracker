extends VBoxContainer

func _process(delta: float) -> void:
	$DayLabel.text = _get_weekday_text(SelectedDay.selected_day)

func _get_weekday_text(selected_day: Dictionary) -> String:
	match selected_day["weekday"]:
		Time.WEEKDAY_MONDAY:
			return "Monday"
		Time.WEEKDAY_TUESDAY:
			return "Tuesday"
		Time.WEEKDAY_THURSDAY:
			return "Thursday"
		Time.WEEKDAY_FRIDAY:
			return "Friday"
		Time.WEEKDAY_SATURDAY:
			return "Saturday"
		Time.WEEKDAY_SUNDAY:
			return "Sunday"
		_:
			return "Wednesday, my dudes."
