extends VBoxContainer
class_name Report

const ACTIVITY_REPORT_ITEM_SCENE: PackedScene = preload("res://src/report/activity_report_item.tscn")

@onready var selected_day: Date = SelectedDay.selected_day
@onready var loaded_data: Array[DailyReport] = _load_data()
@export var interval_start: Date
@export var interval_end: Date

func _ready() -> void:
	_show_report_for_date(selected_day)

func open_new_day(new_day: Date) -> void:
	var reload: bool = _should_reload(selected_day, new_day)
	selected_day = new_day
	if reload:
		loaded_data = _load_data()
	
	_show_report_for_date(get_selected_date())
	
func set_interval(start: Date, end: Date) -> void:
	interval_start = start
	interval_end = end

func _show_report_for_date(selected: Date) -> void:
	for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
		item.queue_free()
	_render_items(_get_report(selected))

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
	
	while current_day.compare(end) <= 0:
		reports.append(LoadedReports.get_daily_report(current_day))
		current_day = Date.get_next(current_day)
	
	return reports

func _render_items(report_data: DailyReport) -> void:
	if not report_data:
		return
	for activity in report_data.get_activities():
		var already_present = false
		for item: ActivityReportItem in get_tree().get_nodes_in_group("report_item"):
			if item.get_activity_name() == activity:
				already_present = true
		if already_present:
			pass
		var new_node: ActivityReportItem = ACTIVITY_REPORT_ITEM_SCENE.instantiate()
		new_node.set_activity_name(activity)
		new_node.set_activity_time(report_data.get_time_for_activity(activity))
		add_child(new_node)
	
func _should_reload(current: Date, new: Date) -> bool:
	if not get_interval_start() or not get_interval_end():
		return current.month != new.month or current.year != new.year
	return false

func _get_report(date: Date) -> DailyReport:
	for report: DailyReport in loaded_data:
		if report.date.compare(date) == 0:
			return report
	
	return null
