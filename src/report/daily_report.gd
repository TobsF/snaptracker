extends Node
class_name DailyReport

var date: Date
var total_time: int
var _activities: Array[ActivityModel]

func _init(init_date: Date, init_activities: Array[ActivityModel]) -> void:
	date = init_date
	_activities = init_activities
	total_time = _compute_total(init_activities)
	
func get_activities() -> Array[ActivityModel]:
	return _activities
	
func get_time_for_activity(activity: ActivityModel) -> ActivityTime:
	return ActivityTime.new(activity.time_seconds, activity.time_seconds / float(total_time))

func _compute_total(activities: Array[ActivityModel]) -> int:
	var total: int = 0
	for activity: ActivityModel in activities:
		total += activity.time_seconds
	return total
