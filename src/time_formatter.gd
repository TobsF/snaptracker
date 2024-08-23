extends Node
class_name TimeFormatter

# Format the time as "HH:MM:SS"
static func format(time_in_seconds: int) -> String:
	var minutes: int = int(time_in_seconds) / 60 % 60
	var seconds: int = int(time_in_seconds) % 60
	var hours: int = int(time_in_seconds) / 3600
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
