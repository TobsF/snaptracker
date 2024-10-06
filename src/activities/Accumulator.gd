extends Node

signal saved(day: Date)

@onready var report_dao: ReportDao = ReportDao.new()

var autosave_enabled: bool = true

func _ready() -> void:
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	if autosave_enabled:
		store_activites()
	await get_tree().create_timer(10).timeout
	_on_timer_timeout()
	
func store_activites() -> void:
	_store_current_tracing()
		
	var nodes: Array[Node] = get_tree().get_nodes_in_group("activity_tracking")
	var new_activities: Array[Activity] = []
	for activity: Node in nodes:
		new_activities.append(activity as Activity)

	if new_activities.size() == 0:
			saved.emit(SelectedDay.selected_day)
			return

	if not is_instance_valid(new_activities[0].model):
		return
	var selected_day: Date = new_activities[0].model.date
	
	var activities_to_save: Array[ActivityModel] = []
	var activities_to_delete: Array[ActivityModel] = []
	for activity: Activity in new_activities:
		if activity.is_marked_for_deletion():
			activities_to_delete.append(activity.model)
		else:
			activities_to_save.append(activity.model)
	var daily_report: DailyReport = DailyReport.new(selected_day, activities_to_save)
	
	if not activities_to_save.is_empty():
		report_dao.update_activities(daily_report)
	if not activities_to_delete.is_empty():
		for model: ActivityModel in activities_to_delete:
			report_dao.delete_activity(model)

	saved.emit(selected_day)

func _store_current_tracing() -> void:
	var node: CurrentTracking = get_tree().get_first_node_in_group("current_tracking")
	if is_instance_valid(node) and is_instance_valid(node.get_current()):
		var current_activity: ActivityModel = node.get_current().model
		report_dao.update_activity(current_activity)
