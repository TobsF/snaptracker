extends VBoxContainer
class_name Report

const ACTIVITY_REPORT_ITEM_SCENE: PackedScene = preload("res://src/report/activity_report_item.tscn")

@onready var selected_day: Date = SelectedDay.selected_day
@onready var loaded_data: Dictionary = _load_data_for_interval()

func _ready() -> void:
	_show_report_for_date(selected_day)

func open_new_day(new_day: Date) -> void:
	selected_day = new_day
	if Date.from_key(loaded_data.keys()[0]).month != selected_day.month:
		loaded_data= _load_data_for_interval()
	
	_show_report_for_date(get_selected_date())

func _show_report_for_date(selected: Date) -> void:
	for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
		item.queue_free()
	_render_items(selected)

func get_interval_start() -> Date:
	return Date.new(1, get_selected_date().month, get_selected_date().year)
	
func get_interval_end() -> Date:
	return Date.new(31, get_selected_date().month, get_selected_date().year)
	
func get_selected_date() -> Date:
	return selected_day
	
# Dictionary: <Date-string, Dictionary<ActivityName as String, String time in seconds>>
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
	
	
