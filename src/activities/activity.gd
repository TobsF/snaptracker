extends HBoxContainer
class_name Activity

var time_seconds: int = 0
var regex: RegEx

func _ready() -> void:
	regex = RegEx.new()
	regex.compile("(\\d+\\d+):(\\d+\\d+):(\\d+\\d+)")

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
	
func is_active() -> bool:
	return $BoxContainer/StopButton.visible

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
	ActivityTopic.activity_stop.emit()
	ActivityTopic.activity_stop.connect(_on_stop_button_pressed)
	$BoxContainer/PlayButton.visible = false
	$BoxContainer/StopButton.visible = true
	$Timer.start()


func _on_stop_button_pressed() -> void:
	$BoxContainer/PlayButton.visible = true
	$BoxContainer/StopButton.visible = false
	$Timer.stop()
	ActivityTopic.activity_stop.disconnect(_on_stop_button_pressed)


func _on_timer_timeout() -> void:
	time_seconds += 1
