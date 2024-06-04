extends HBoxContainer
class_name Activity

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

@onready var deletion_sprite: Sprite2D = %DeletionSprite
@onready var to_be_deleted: Node = %ToBeDeleted

var delete_released: bool = false
var deletion_counter: int = 0
var marked_for_deletion: bool = false
var deletion_timestamp: int
var time_seconds: int = 0
var date: Date
var regex: RegEx
var _old_name: String

func _ready() -> void:
	regex = RegEx.new()
	regex.compile("(\\d+\\d+):(\\d+\\d+):(\\d+\\d+)")
	_old_name = get_activity_name()

func _process(_delta: float) -> void:
	var minutes: int = int(time_seconds) / 60 % 60
	var seconds: int = int(time_seconds) % 60
	var hours: int = int(time_seconds) / 3600
	
	# Format the time as "HH:MM:SS"
	var formatted_time: String = "%02d:%02d:%02d" % [hours, minutes, seconds]
	$TimerEdit.text = formatted_time
	
func get_allotted_time() -> int:
	return time_seconds
	
func get_activity_name() -> String:
	return $ActivityEdit.text
	
func set_allotted_time(time: int) -> void:
	time_seconds = time

func set_activity_name(new_name: String) -> void:
	$ActivityEdit.text = new_name

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
	var match: RegExMatch = regex.search(new_text)
	if match != null and new_text.length() == 8 and match.get_group_count() == 3:
		var hours: int = int(match.get_string(1))
		var minutes: int = int(match.get_string(2)) % 60
		var seconds: int = int(match.get_string(3)) % 60
		time_seconds = (hours * 60 * 60) + (minutes * 60) + seconds
		
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
	time_seconds += 1

func _on_activity_edit_text_changed(new_text: String) -> void:
	var caret_column = %ActivityEdit.caret_column
	_add_stale_name(_old_name, new_text.to_upper())
	%ActivityEdit.text = new_text.to_upper()
	%ActivityEdit.caret_column = caret_column
	_old_name = %ActivityEdit.text


func _on_delete_button_button_down() -> void:
	_increase_deletion_counter()

func _increase_deletion_counter():
	if delete_released:
		deletion_counter = 0
		delete_released = false
		deletion_sprite.scale.y = 0
	elif deletion_counter >= 10:
		deletion_timestamp = Time.get_ticks_msec()
		hide()
	else:
		deletion_counter += 1
		var tween: Tween = create_tween()
		tween.tween_property(deletion_sprite, "scale:y", deletion_sprite.scale.y + 0.1 , 0.1)
		tween.parallel().tween_callback(_increase_deletion_counter).set_delay(0.1)

func _on_delete_button_button_up() -> void:
	delete_released = true

func _add_stale_name(stale_name: String, new_name: String) -> void:
	for stale: Activity in to_be_deleted.get_children():
		if stale.get_activity_name() == new_name or (Time.get_ticks_msec() - stale.deletion_timestamp) > 30000:
			stale.queue_free()
	
	var stale_node: Activity = ACTIVITY_RESOURCE.instantiate()
	stale_node.set_activity_name(stale_name)
	stale_node.deletion_timestamp = Time.get_ticks_msec()
	stale_node.hide()
	to_be_deleted.add_child(stale_node)
