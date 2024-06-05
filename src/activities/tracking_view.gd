extends VBoxContainer
class_name TrackingView

signal to_compact_view()

@onready var daily_activities: DailyActivities = %DailyActivities

func _on_fold_button_pressed() -> void:
	to_compact_view.emit()

func _on_day_selector_new_day(_old_day: Date, new_day: Date) -> void:
	daily_activities.open_new_day(new_day)

func init_active(activty_name: String, time: int) -> void:
	for tracker: Activity in get_tree().get_nodes_in_group("activity_tracking"):
		if tracker.get_activity_name() == activty_name:
			tracker.time_seconds = time
			tracker.activate()
