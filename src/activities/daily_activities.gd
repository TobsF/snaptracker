extends VBoxContainer
class_name DailyActivities

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

func _ready() -> void:
	_create_activities_from_day(SelectedDay.selected_day)

func _process(_delta: float) -> void:
	%DayLabel.text = _get_weekday_text(SelectedDay.selected_day)

func open_new_day(new_selected_day: Dictionary) -> void:
	var accumulator: Accumulator = get_tree().get_first_node_in_group("accumulator")
	accumulator.store_activites(SelectedDay.selected_day)
	for tracker: Node in get_tree().get_nodes_in_group("activity_tracking"):
		tracker.queue_free()
	_create_activities_from_day(new_selected_day)


func _create_activities_from_day(selected_day: Dictionary) -> void:
	var accumulator: Accumulator = get_tree().get_first_node_in_group("accumulator")
	var activity_dict: Dictionary = accumulator.read_daily_from_file(selected_day)
	for activity_label: String in activity_dict:
		var activity: Activity = ACTIVITY_RESOURCE.instantiate()
		activity.set_activity_name(activity_label)
		activity.set_allotted_time(activity_dict[activity_label])
		%ActivityContainer.add_child(activity)	

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
