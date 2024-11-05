extends VBoxContainer
class_name CurrentTracking

static var is_tracking: bool = false

signal clicked(current: Activity)

@onready var activity_name: Label = %ActivityName

var _current: Activity

func set_current(activity: Activity) -> void:
	activity.hide()
	activity.reparent(self)
	_current = activity
	activity_name.text = activity.get_activity_name()
	show()
	is_tracking = true
	ActivityTopic.current_tracking_changed.emit(is_tracking)
	
func get_current() -> Activity:
	return _current
	
func clear() -> void:
	hide()
	_current.free()
	is_tracking = false
	ActivityTopic.current_tracking_changed.emit(is_tracking)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(_current)

func _on_mouse_entered() -> void:
	GlobalTextTopic.new_text.emit("Left-click to return to tracked activity")

func _on_mouse_exited() -> void:
	GlobalTextTopic.new_text.emit("")
