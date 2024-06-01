extends Node

const FILE_NAME: String = "activities.json"

func _on_timer_timeout() -> void:
	var activity_dict: Dictionary = {}
	for activity: Activity in get_tree().get_nodes_in_group("activity_tracking"):
		if not activity.get_activity_name().is_empty():
			var key_to_upper: String = activity.get_activity_name().to_upper()
			if activity_dict.has(key_to_upper):
				activity_dict[key_to_upper] += activity.get_allotted_time()
			else:
				activity_dict[key_to_upper] = activity.get_allotted_time()
	_store_activities({Time.get_date_string_from_system(true): activity_dict})
		
	
func _store_activities(dict: Dictionary) -> void:
	var file: FileAccess = FileAccess.open("user://%s" % FILE_NAME , FileAccess.WRITE)
	var stringified: String = JSON.stringify(dict, "\t")
	file.store_string(stringified)
	file.close()

#func read_file(scene_name : String) -> Dictionary:
	#var file = FileAccess.open(file_identifier_format % scene_name , FileAccess.READ)
	#var content = file.get_as_text()
	#var json = JSON.new()
	#var error = json.parse(content)
	#var data
	#if error == OK:
		#data = json.data
	#else:
		#print(json.get_error_message())
	#return data
