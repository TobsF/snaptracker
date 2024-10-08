extends VBoxContainer
class_name DailyActivities

@onready var activity_container: VBoxContainer = %ActivityContainer

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

func _ready() -> void:
	_create_activities_from_day(SelectedDay.selected_day)

func _process(_delta: float) -> void:
	%DayLabel.text = _get_weekday_text(SelectedDay.selected_day)

func open_new_day(new_selected_day: Date) -> void:
	Accumulator.store_activites()
	for tracker: Node in activity_container.get_children():
		tracker.queue_free()
	_create_activities_from_day(new_selected_day)

func _create_activities_from_day(selected_day: Date) -> void:
	var report: DailyReport = LoadedReports.get_daily_report(selected_day)
	for model: ActivityModel in report.get_activities():
		var activity: Activity = ACTIVITY_RESOURCE.instantiate()
		activity.model = model
		%ActivityContainer.add_child(activity)	

func _get_weekday_text(selected_day: Date) -> String:
	match selected_day.weekday:
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
			
func get_activity_nodes() -> Array[Node]:
	return activity_container.get_children()
