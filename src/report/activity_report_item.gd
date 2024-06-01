extends HBoxContainer
class_name ActivityReportItem

var _activity_time: int

func set_activity_name(activity_name: String) -> void:
	%ActivityName.text = activity_name
	
func get_activity_name() -> String:
	return %ActivityName.text

func set_activity_time(activity_time: int) -> void:
	_activity_time = activity_time
	var hours: float = float(activity_time) / 3600
	if hours < 0.01:
		visible = false
	%ActivityTime.text = String.num(float(activity_time) / 3600, 2)

func set_percentage(percentage: float) -> void:
	#todo
	pass
