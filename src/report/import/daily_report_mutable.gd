extends DailyReport
class_name DailyReportMutable

func _init(init_date: Date) -> void:
	super._init(init_date, [])
	
func add_activity(activity: ActivityModel) -> void:
	_activities.append(activity)
	total_time = _compute_total(_activities)
