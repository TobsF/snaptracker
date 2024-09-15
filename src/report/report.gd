extends VBoxContainer
class_name Report

const ACTIVITY_REPORT_ITEM_SCENE: PackedScene = preload("res://src/report/activity_report_item.tscn")

@onready var selected_day: Date = SelectedDay.selected_day
@onready var loaded_data: Array[DailyReport] = _load_data()
@export var interval_start: Date
@export var interval_end: Date
@export var total_toggled: bool = false:
	set(new_total_toggled): 
		total_toggled = new_total_toggled
		if new_total_toggled:
			_open_interval()
		else:
			open_new_day(selected_day)

var _interval_times: Dictionary = {}
var _interval_total_time: int = 0

func _ready() -> void:
	_show_report_for_date(selected_day)

func open_new_day(new_day: Date) -> void:
	var reload: bool = _should_reload(selected_day, new_day)
	selected_day = new_day
	if reload:
		loaded_data = _load_data()
	
	_show_report_for_date(get_selected_date())
	
func clear_interval() -> void:
	interval_start = null
	interval_end = null
	total_toggled = false
	
func set_interval(start: Date, end: Date) -> void:
	interval_start = start
	interval_end = end
	_load_data_for_interval(interval_start, interval_end)
	
func _open_interval() -> void:
	for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
		item.queue_free()
	_render_items(_interval_times.keys())
	
func _show_report_for_date(selected: Date) -> void:
	for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
		item.queue_free()
	var daily_report: DailyReport = _get_report(selected)
	_render_items(_get_report(selected).get_activities() if daily_report else [])

func get_interval_start() -> Date:
	return interval_start
	
func get_interval_end() -> Date:
	return interval_end
	
func get_selected_date() -> Date:
	return selected_day

func _load_data() -> Array[DailyReport]:
	return _load_data_for_interval(Date.new(1, get_selected_date().month, get_selected_date().year), 
		Date.new(31, get_selected_date().month, get_selected_date().year))

func _load_data_for_interval(start: Date, end: Date) -> Array[DailyReport]:
	var reports: Array[DailyReport] = []
	var current_day: Date = start
	_interval_times.clear()
	_interval_total_time = 0
	
	while current_day.compare(end) <= 0:
		var daily_report: DailyReport = LoadedReports.get_daily_report(current_day)
		if daily_report:
			reports.append(daily_report)
			for activity: ActivityModel in daily_report.get_activities():
				_interval_total_time += daily_report.get_time_for_activity(activity).time
				if _interval_times.has(activity.name):
					_interval_times[activity.name] += daily_report.get_time_for_activity(activity).time
				else:
					_interval_times[activity.name] = daily_report.get_time_for_activity(activity).time
		current_day = Date.get_next(current_day)
	
	return reports

func _render_items(activities: Array) -> void:
	if not activities:
		return
	for activity: ActivityModel in activities:
		_add_activity(activity.name, _get_time(activity), _get_percentage(activity))

func _add_activity(activity_name: String, time: int, percentage: float) -> void:
	var already_present = false
	for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
		if item.get_activity_name() == activity_name:
			already_present = true
	if already_present:
		pass
	var new_node: ActivityReportItem = ACTIVITY_REPORT_ITEM_SCENE.instantiate()
	new_node.set_activity_name(activity_name)
	new_node.set_activity_time(time)
	new_node.set_percentage(percentage)
	add_child(new_node)
	
func _should_reload(current: Date, new: Date) -> bool:
	if not _is_interval_chosen():
		return current.month != new.month or current.year != new.year
	return false

func _get_report(date: Date) -> DailyReport:
	for report: DailyReport in loaded_data:
		if report.date.compare(date) == 0:
			return report
	
	return null

func _is_interval_chosen() -> bool:
	return get_interval_start() and get_interval_end()
	
func _is_total() -> bool:
	return total_toggled
	
func _get_percentage(activity: ActivityModel) -> float:
	if _is_total():
		return _interval_times[activity.name] / float(_interval_total_time)
	else:
		return _get_report(get_selected_date()).get_time_for_activity(activity).percentage_of_daily

func _get_time(activity: ActivityModel) -> int:
	if _is_total():
		return _interval_times[activity.name]
	else:
		return _get_report(get_selected_date()).get_time_for_activity(activity).time
			
		
