extends Node
class_name Date

static func get_days_in_month() ->  Array[int]: 
	var days_in_month: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	var datetime: Date
	if SelectedDay.selected_day:
		datetime = SelectedDay.selected_day.duplicated()
	else:
		datetime = Date.current_as_date()
	if datetime.year % 4 == 0 and (datetime.year % 100 != 0 or datetime.year % 400 == 0):
		days_in_month[1] = 29
	else: 
		days_in_month[1] = 28
	return days_in_month

func _init(init_day: int, init_month: int, init_year: int) -> void:
	self.day = init_day
	self.month = init_month
	self.year = init_year
	
static func current_as_date() -> Date:
	var current_dictionary: Dictionary = Time.get_date_dict_from_system(true)
	var date: Date = Date.new(int(current_dictionary["day"]), int(current_dictionary["month"]), int(current_dictionary["year"]))
	date.weekday = current_dictionary["weekday"]
	return date
	
func duplicated() -> Date:
	var duplicated_date: Date = Date.new(day, month, year)
	duplicated_date.weekday = weekday
	return duplicated_date
	
var day: int
var month: int
var year: int
var weekday: int

# less than = -1
# equal = 0
# more than = 1
func compare(other: Date) -> int:
	if self.year < other.year:
		return -1
	if self.year > other.year:
		return 1
	
	if self.month < other.month:
		return -1
	if self.month > other.month:
		return 1

	if self.day < other.day:
		return -1
	if self.day > other.day:
		return 1

	return 0
	
static func from_key(key: String) -> Date:
	var splitted: PackedStringArray = key.split("-")
	return Date.new(int(splitted[0]), int(splitted[1]), int(splitted[2]))
	
func to_key() -> String:
	return "%s-%s-%s" % [day, month, year]
