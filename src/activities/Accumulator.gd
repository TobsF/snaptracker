extends Node

signal saved

var autosave_enabled: bool = true

func _ready() -> void:
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	if autosave_enabled:
		store_activites()
	await get_tree().create_timer(10).timeout
	_on_timer_timeout()
	
func store_activites() -> void:
	var nodes: Array[Node] = get_tree().get_nodes_in_group("activity_tracking")
	var new_activities: Array[Activity] = []
	for activity: Node in nodes:
		new_activities.append(activity as Activity)
	var selected_day: Date
	if new_activities.size() == 0:
		return
	else:
		selected_day = new_activities[0].date
	var activity_dict: Dictionary = _read_file(selected_day.month, selected_day.year)
	var existing_dailies: Dictionary = activity_dict[selected_day.to_key()] if activity_dict.has(selected_day.to_key()) else {}
	activity_dict[selected_day.to_key()] = _compute_new_daily_activities(existing_dailies, new_activities)
	_store_activities(activity_dict, selected_day.month, selected_day.year)
	saved.emit()

func read_daily_from_file(selected_day: Date) -> Dictionary:
	var monthly_file: Dictionary = _read_file(selected_day.month, selected_day.year)
	if monthly_file.has(selected_day.to_key()):
		return monthly_file[selected_day.to_key()]
	else:
		return {}
	
func _store_activities(dict: Dictionary, month: int, year: int) -> void:
	var file: FileAccess = FileAccess.open("user://%02d-%04d-%s" % [month, year, ActivitiesReader.FILE_NAME]  , FileAccess.WRITE)
	var json_string: String = JSON.stringify(dict, "\t")
	file.store_string(json_string)
	file.close()

func _read_file(month: int, year: int) -> Dictionary:
	return ActivitiesReader.read_monthly_activites(month, year)

func _compute_new_daily_activities(existing_activities: Dictionary, activities: Array[Activity]) -> Dictionary:
	var new_activites: Dictionary = {}
	var to_be_deleted: Array[String] = []
	for activity: Activity in activities:
		if not activity.get_activity_name().is_empty():
			var key_to_upper: String = activity.get_activity_name().to_upper()
			if activity.is_marked_for_deletion():
				to_be_deleted.append(key_to_upper)
			if new_activites.has(key_to_upper):
				new_activites[key_to_upper] += activity.get_allotted_time()
			else:
				new_activites[key_to_upper] = activity.get_allotted_time()
	new_activites.merge(existing_activities)
	for key_to_be_deleted: String in to_be_deleted:
		new_activites.erase(key_to_be_deleted)
	return new_activites
