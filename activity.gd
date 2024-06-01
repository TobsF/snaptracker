extends HBoxContainer

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

func _update_from_input(nex_text: String) -> void:
	var match: RegExMatch = regex.search(nex_text)
	if match != null and match.get_group_count() == 3:
		var hours: int = int(match.get_string(1)) % 60
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
