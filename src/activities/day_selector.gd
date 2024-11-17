extends HBoxContainer
class_name DaySelector

signal new_day(old_day: Date, new_day: Date)

@onready var selected_day: Date = SelectedDay.selected_day.duplicated()
@export var interval_start: Date
@export var interval_end: Date

func _ready() -> void:
	_update_date_diplay()

func set_interval(start: Date, end: Date)  -> void:
	interval_start = start
	interval_end = end
	new_day.emit(SelectedDay.selected_day, interval_start.duplicated())
	selected_day = interval_start.duplicated()
	SelectedDay.selected_day = selected_day.duplicated()
	
	%PreviousDayButton.hide()
	if Date.get_next(selected_day).compare(interval_end) <= 0:
		%NextDayButton.show()

	_update_date_diplay()
	
func clear_interval() -> void:
	interval_start = null
	interval_end = null
	_reset_date()


func _reset_date() -> void:
	var old_day = selected_day
	selected_day = Date.current_as_date()
	SelectedDay.selected_day = Date.current_as_date()
	new_day.emit(old_day, selected_day.duplicated())
	
	%PreviousDayButton.show()
	%NextDayButton.show()
	
	_update_date_diplay()

func _on_previous_day_button_pressed() -> void:
	selected_day = Date.get_previous(selected_day)
	new_day.emit(SelectedDay.selected_day, selected_day.duplicated())
	SelectedDay.selected_day = selected_day.duplicated()
	
	%NextDayButton.show()
	if interval_start and selected_day.compare(interval_start) <= 0:
		%PreviousDayButton.hide()
		
	_update_date_diplay()

func _on_next_day_button_pressed() -> void:
	selected_day = Date.get_next(selected_day)
	new_day.emit(SelectedDay.selected_day, selected_day.duplicated())
	SelectedDay.selected_day = selected_day.duplicated()
	
	%PreviousDayButton.show()
	if interval_end and selected_day.compare(interval_end) >= 0:
		%NextDayButton.hide()
		
	_update_date_diplay()

func _update_date_diplay() -> void:
	%DateLabel.text = "%s.%s.%s" % [selected_day.day, selected_day.month, selected_day.year]
	if selected_day.compare(Date.current_as_date()) != 0 and not _is_interval_set():
		%ResetDateButton.show()
	else:
		%ResetDateButton.hide()

func _is_interval_set() -> bool:
	return is_instance_valid(interval_start) and is_instance_valid(interval_end)

func _on_reset_date_button_pressed() -> void:
	_reset_date()
