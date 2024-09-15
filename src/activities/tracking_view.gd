extends VBoxContainer
class_name TrackingView

signal to_compact_view()
signal currently_active_hidden(current: Activity)
signal new_day_selected(new_day: Date)

@onready var daily_activities: DailyActivities = %DailyActivities

func _on_fold_button_pressed() -> void:
	to_compact_view.emit()

func _on_day_selector_new_day(_old_day: Date, new_day: Date) -> void:
	for tracker: Activity in daily_activities.get_activity_nodes():
		if tracker.is_active():
			currently_active_hidden.emit(tracker)
			
	daily_activities.open_new_day(new_day)
	new_day_selected.emit(new_day)

func init_active(activty_name: String, time: int) -> void:
	for tracker: Activity in daily_activities.get_activity_nodes():
		if tracker.get_activity_name() == activty_name:
			tracker.set_allotted_time(time)
			tracker.activate()
