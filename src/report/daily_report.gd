extends Node
class_name DailyReport

var date: Date
var total_time: int
var _activities: Dictionary

func _init(init_date: Date, init_activities: Dictionary) -> void:
	date = init_date
	_activities = init_activities
	total_time = _compute_total(init_activities)
	
func get_activities() -> Array:
	return _activities.keys()
	
func get_time_for_activity(activity: String) -> ActivityTime:
	if _activities.has(activity):
		var time: int = int(_activities[activity])
		return ActivityTime.new(time, time / float(total_time))
	else:
		return ActivityTime.new(0, 0.0)

func _compute_total(activities: Dictionary) -> int:
	var total: int = 0
	for activity: String in activities:
		total += int(activities[activity])
	return total
