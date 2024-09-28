extends Node
class_name TimeFormatter

static var regex: RegEx = RegEx.new()

# Format the time as "HH:MM:SS"
static func format(time_in_seconds: int) -> String:
	var minutes: int = int(time_in_seconds) / 60 % 60
	var seconds: int = int(time_in_seconds) % 60
	var hours: int = int(time_in_seconds) / 3600
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

static func parse(time_string: String) -> int:
	regex.compile("(\\d+\\d+):(\\d+\\d+):(\\d+\\d+)")
	var result: int = 0
	var match: RegExMatch = regex.search(time_string)
	if match != null and time_string.length() == 8 and match.get_group_count() == 3:
		var hours: int = int(match.get_string(1))
		var minutes: int = int(match.get_string(2)) % 60
		var seconds: int = int(match.get_string(3)) % 60
		result = (hours * 60 * 60) + (minutes * 60) + seconds
	return result
