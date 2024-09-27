extends HBoxContainer
class_name Activity

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

@onready var deletion_sprite: Sprite2D = %DeletionSprite
@onready var box_container: BoxContainer = $BoxContainer

var model: ActivityModel
var delete_released: bool = false
var deletion_counter: int = 0
var deletion_timestamp: int

func _ready() -> void:
	set_activity_name(model.name)

func _process(_delta: float) -> void:
	$TimerEdit.text = TimeFormatter.format(model.time_seconds)
	box_container.visible = not CurrentTracking.is_tracking
	
func get_allotted_time() -> int:
	return model.time_seconds
	
func get_activity_name() -> String:
	return $ActivityEdit.text
	
func set_allotted_time(time: int) -> void:
	model.time_seconds = time

func set_activity_name(new_name: String) -> void:
	model.name = new_name
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


func _on_activity_edit_text_changed(new_text: String) -> void:
	model.name = new_text
