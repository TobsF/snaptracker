extends Node
class_name ActivitiesReader

const FILE_NAME: String = "activities.json"

static func read_monthly_activites(month: int, year: int) -> Dictionary:
	var file: FileAccess = FileAccess.open("user://%02d-%04d-%s" % [month, year, FILE_NAME] , FileAccess.READ_WRITE)
	if file == null:
		file = FileAccess.open("user://%02d-%04d-%s" % [month, year, FILE_NAME] , FileAccess.WRITE_READ)
	var content: String = file.get_as_text()
	var json: JSON = JSON.new()
	var error = json.parse(content)
	var data: Dictionary = {}
	if error == OK:
		data = json.data
	else:
		print(json.get_error_message())
	file.close()
	return data
