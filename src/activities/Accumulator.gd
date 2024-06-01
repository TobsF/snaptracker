extends Node
class_name Accumulator

const FILE_NAME: String = "activities.json"

func _on_timer_timeout() -> void:
	store_activites(SelectedDay.selected_day)
	
func store_activites(selected_day: Dictionary) -> void:
	var activity_dict: Dictionary = _read_file(selected_day["month"], selected_day["year"])
	activity_dict[_get_date_formatted(selected_day)] = _compute_new_daily_activities()
	_store_activities(activity_dict, selected_day["month"], selected_day["year"])

func read_daily_from_file(selected_day: Dictionary) -> Dictionary:
	var monthly_file: Dictionary = _read_file(selected_day["month"], selected_day["year"])
	if monthly_file.has(_get_date_formatted(selected_day)):
		return monthly_file[_get_date_formatted(selected_day)]
	else:
		return {}
	
func _store_activities(dict: Dictionary, month: int, year: int) -> void:
	var file: FileAccess = FileAccess.open("user://%02d-%04d-%s" % [month, year, FILE_NAME]  , FileAccess.WRITE)
	var json_string: String = JSON.stringify(dict, "\t")
	file.store_string(json_string)
	file.close()

func _read_file(month: int, year: int) -> Dictionary:
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

func _compute_new_daily_activities() -> Dictionary:
	var new_activites: Dictionary = {}
	for activity: Activity in get_tree().get_nodes_in_group("activity_tracking"):
		if not activity.get_activity_name().is_empty():
			var key_to_upper: String = activity.get_activity_name().to_upper()
			if new_activites.has(key_to_upper):
				new_activites[key_to_upper] += activity.get_allotted_time()
			else:
				new_activites[key_to_upper] = activity.get_allotted_time()
	return new_activites

func _get_date_formatted(date: Dictionary) -> String:
	return "%s-%s-%s" % [date["day"], date["month"], date["year"]]
