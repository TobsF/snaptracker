extends Node

const FILE_NAME: String = "activities.json"

func _on_timer_timeout() -> void:
	store_activites(SelectedDay.selected_day)
	
func store_activites(selected_day: Dictionary) -> void:
	var activity_dict: Dictionary = _read_file(selected_day["month"], selected_day["year"])
	var stored_daily_activity_dict: Dictionary = {}
	if activity_dict.has(_get_date_formatted(selected_day)):
		stored_daily_activity_dict = activity_dict[_get_date_formatted(selected_day)]
	var new_activities: Dictionary = _compute_new_daily_activities()
	for key: String in new_activities.keys():
		if stored_daily_activity_dict.has(key):
			stored_daily_activity_dict[key] += new_activities[key]
		else:
			stored_daily_activity_dict[key] = new_activities[key]
	activity_dict[_get_date_formatted(selected_day)] = stored_daily_activity_dict
	_store_activities(activity_dict, selected_day["month"], selected_day["year"])
	
	
func _store_activities(dict: Dictionary, month: int, year: int) -> void:
	var file: FileAccess = FileAccess.open("user://%02d-%04d-%s" % [month, year, FILE_NAME]  , FileAccess.READ_WRITE)
	file.store_string(JSON.stringify(dict, "\t"))
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
