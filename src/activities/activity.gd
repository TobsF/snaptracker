extends HBoxContainer
class_name Activity

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

@onready var box_container: BoxContainer = $BoxContainer

var model: ActivityModel
var deletion_timestamp: int
var recent: RecentActivitiesDropdown

func _ready() -> void:
	set_activity_name(model.name)

func _process(_delta: float) -> void:
	$TimerEdit.text = TimeFormatter.format(model.time_seconds)
	box_container.visible = not CurrentTracking.is_tracking
	
func get_allotted_time() -> int:
	return model.time_seconds
	
func get_activity_name() -> String:
	return %ActivityEdit.text
	
func set_allotted_time(time: int) -> void:
	model.time_seconds = time

func set_activity_name(new_name: String) -> void:
	model.name = new_name
	%ActivityEdit.text = new_name

func activate() -> void:
	ActivityTopic.activity_stop.emit()
	ActivityTopic.activity_stop.connect(_on_stop_button_pressed)
	$BoxContainer/PlayButton.visible = false
	$BoxContainer/StopButton.visible = true
	$Timer.start()
	
func is_active() -> bool:
	return $BoxContainer/StopButton.visible
	
func is_marked_for_deletion() -> bool:
	if deletion_timestamp:
		return true
	return false

func _update_from_input(new_text: String) -> void:
	var parse_result: int = TimeFormatter.parse(new_text)
	if parse_result > 0:
		model.time_seconds = parse_result
		
	set_process(true)

func _on_timer_edit_text_submitted(new_text: String) -> void:
	_update_from_input(new_text)

func _on_timer_edit_focus_entered() -> void:
	set_process(false)

func _on_timer_edit_focus_exited() -> void:
	_update_from_input($TimerEdit.text)

func _on_play_button_pressed() -> void:
	activate()

func _on_stop_button_pressed() -> void:
	$BoxContainer/PlayButton.visible = true
	$BoxContainer/StopButton.visible = false
	$Timer.stop()
	ActivityTopic.activity_stop.disconnect(_on_stop_button_pressed)

func _on_timer_timeout() -> void:
	model.time_seconds += 1

func _on_activity_edit_text_changed(new_text: String) -> void:
	model.name = new_text
	if not is_instance_valid(recent):
		_add_dropdown()
	recent.on_new_input(new_text)

func _on_recent_activities_dropdown_suggestion_accepted(suggestion: String) -> void:
	set_activity_name(suggestion)
	%ActivityEdit.caret_column = suggestion.length()
	_remove_dropdown()

func _on_activity_edit_focus_entered() -> void:
	_add_dropdown()

func _on_activity_edit_focus_exited() -> void:
	_remove_dropdown()

func _add_dropdown() -> void:
	if is_instance_valid(recent):
		return
	recent = RecentActivitiesDropdown.SCENE.instantiate()
	recent.z_index = 1
	recent.suggestion_accepted.connect(_on_recent_activities_dropdown_suggestion_accepted)
	%VBoxContainer.add_child(recent)

func _remove_dropdown() -> void:
	if is_instance_valid(recent):
		recent.queue_free()

func _on_delete_button_deleted() -> void:
	deletion_timestamp = Time.get_ticks_msec()
	hide()
