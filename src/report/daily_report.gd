extends Node
class_name DailyReport

var date: Date
var _activities: Dictionary

func _init(init_date: Date, init_activities: Dictionary) -> void:
	date = init_date
	_activities = init_activities
	
func get_activities() -> Array:
	return _activities.keys()
	
func get_time_for_activity(activity: String) -> int:
	if _activities.has(activity):
		return int(_activities[activity])
	else:
		return 0
