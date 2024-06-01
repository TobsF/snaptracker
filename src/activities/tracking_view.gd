extends VBoxContainer
class_name TrackingView

signal to_compact_view()

@onready var daily_activities: DailyActivities = %DailyActivities

func _on_fold_button_pressed() -> void:
	to_compact_view.emit()

func _on_day_selector_new_day(old_day: Date, new_day: Date) -> void:
	daily_activities.open_new_day(old_day, new_day)
