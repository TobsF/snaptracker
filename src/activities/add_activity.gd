extends BoxContainer

@export var target_container: Container

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

@onready var report_dao: ReportDao = ReportDao.new()

func _on_pressed() -> void:
	var activity: Node = ACTIVITY_RESOURCE.instantiate()
	activity.model = report_dao.add_new_activity(SelectedDay.selected_day)
	target_container.add_child(activity)
