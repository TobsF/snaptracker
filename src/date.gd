extends Node
class_name Date

static func get_days_in_month() ->  Array[int]: 
	var days_in_month: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	var datetime 
	if SelectedDay.selected_day:
		datetime = SelectedDay.selected_day.duplicate()
	else:
		datetime = Time.get_datetime_dict_from_system(true)
	if datetime["year"] % 4 == 0 and (datetime["year"] % 100 != 0 or datetime["year"] % 400 == 0):
		days_in_month[1] = 29
	else: 
		days_in_month[1] = 28
	return days_in_month

func _init(init_day: int, init_month: int, init_year: int) -> void:
	self.day = init_day
	self.month = init_month
	self.year = init_year
	
var day: int
var month: int
var year: int

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
