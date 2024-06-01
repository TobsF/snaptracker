extends HBoxContainer
class_name IntervalPicker

signal new_interval(start: Date, end: Date)
signal reset_interval()

@onready var item_list: ItemList = %ItemList
@onready var month_label: Label = %MonthLabel
@onready var year_label: Label = %YearLabel

var select_first: bool = true
var selected_start: Date:
	set(new_date):
		selected_start = new_date
		if selected_start:
			%SelectedStartLabel.text = new_date.to_key()
		else:
			%SelectedStartLabel.text = ""
var selected_end: Date:
	set(new_date):
		selected_end = new_date
		if selected_end:
			%SelectedEndLabel.text = new_date.to_key()
		else:
			%SelectedEndLabel.text = ""
var month: int
var year: int

func _ready() -> void:
	var date_dict: Dictionary = Time.get_date_dict_from_system(true)
	month = int(date_dict["month"])
	year = int(date_dict["year"])
	_fill_items(month)

func clear_interval() -> void:
	select_first = true
	selected_start = null
	selected_end = null
	_fill_items(month)
	reset_interval.emit()
	

func _fill_items(for_month: int) -> void:
	month_label.text = _month_to_string(for_month)
	year_label.text = str(year)
	item_list.clear()
	for day_of_month in Date.get_days_in_month()[for_month-1]:
		item_list.add_item(str(day_of_month + 1))


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if select_first:
		item_list.deselect_all()
		item_list.select(index)
		selected_start = Date.new(index + 1, month, year)
		selected_end = null
	else:
		selected_end = Date.new(index + 1, month, year)
		if selected_end.compare(selected_start) < 0:
			var temp: Date = selected_end
			selected_end = selected_start
			selected_start = temp
		_connect_interval()
		new_interval.emit(selected_start, selected_end)
	select_first = not select_first

func _month_to_string(target_month: int) -> String:
	match target_month:
		Time.MONTH_JANUARY:
			return "January"
		Time.MONTH_FEBRUARY:
			return "February"
		Time.MONTH_MARCH:
			return "March"
		Time.MONTH_APRIL:
			return "April"
		Time.MONTH_MAY:
			return "May"
		Time.MONTH_JUNE:
			return "June"
		Time.MONTH_JULY:
			return "July"
		Time.MONTH_AUGUST:
			return "August"
		Time.MONTH_SEPTEMBER:
			return "September"
		Time.MONTH_OCTOBER:
			return "October"
		Time.MONTH_NOVEMBER:
			return "November"
		_:
			return "December"
			
func _connect_interval() -> void:
	if not selected_start or not selected_end:
		return
	for day in range(1, Date.get_days_in_month()[month - 1] + 1):
		var selectable_date: Date = Date.new(day, month, year)
		if selectable_date.compare(selected_start) >= 0 and selectable_date.compare(selected_end) <= 0:
			item_list.select(day - 1, false)
		
func _on_next_month_pressed() -> void:
	month = (month + 1) % 13
	if month == 0:
		month = 1
		year += 1
	_fill_items(month)
	_connect_interval()

func _on_previous_month_pressed() -> void:
	month = month - 1
	if month == 0:
		month = 12
		year -= 1
	_fill_items(month)
	_connect_interval()
