extends VBoxContainer

const ACTIVITY_REPORT_ITEM_SCENE: PackedScene = preload("res://src/report/activity_report_item.tscn")

@onready var loaded_data: Dictionary = _load_data_for_interval()
@onready var selected_day: Date = SelectedDay.as_date()

func _ready() -> void:
	open_new_day({"day": selected_day.day, "month": selected_day.month, "year": selected_day.year})

func open_new_day(new_day: Dictionary) -> void:
	selected_day = Date.new(int(new_day["day"]), int(new_day["month"]), int(new_day["year"]))
	for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
		item.queue_free()
	_render_items(get_selected_date())

func get_interval_start() -> Date:
	return Date.new(1, 5, 2024)
	
func get_interval_end() -> Date:
	return Date.new(31, 5, 2024)
	
func get_selected_date() -> Date:
	return selected_day
	
# Dictionary: <Date, Dictionary<ActivityName as String, String time in seconds>>
func _load_data_for_interval() -> Dictionary:
	var mapped_data: Dictionary = {}
	var activity_dict: Dictionary = ActivitiesReader.read_monthly_activites(get_interval_start().month, get_interval_start().year)
	for key in activity_dict.keys():
		var mapped_key: Date = Date.from_key(key)
		if mapped_key.compare(get_interval_end()) <= 0:
			mapped_data[key] = activity_dict[key]
	
	return mapped_data
	
func _activity_dict_key_to_date(key: String) -> Date:
	var splitted: PackedStringArray = key.split("-")
	return Date.new(int(splitted[0]), int(splitted[1]), int(splitted[2]))

func _render_items(date: Date) -> void:
	if not loaded_data.has(date.to_key()):
		return
	for activity in loaded_data[date.to_key()]:
		var already_present = false
		for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
			if item.get_activity_name() == activity:
				already_present = true
		if already_present:
			pass
		var new_node: ActivityReportItem = ACTIVITY_REPORT_ITEM_SCENE.instantiate()
		new_node.set_activity_name(activity)
		new_node.set_activity_time(int(loaded_data[date.to_key()][activity]))
		add_child(new_node)
	
	
