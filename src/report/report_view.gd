extends VBoxContainer

var interval_start: Date
var interval_end: Date
var selected_day: Date

@onready var interval_picker: IntervalPicker = %IntervalPicker
@onready var report: Report = %Report
@onready var day_selector: DaySelector = %DaySelector
@onready var total_label: Label = %TotalLabel
@onready var total_check_button: CheckButton = %TotalCheckButton
@onready var interval_control_container: HBoxContainer = %IntervalControlContainer
@onready var export: CsvExport = $ButtonMargin/HButtonContainer/Export

func _ready() -> void:
	selected_day = SelectedDay.selected_day.duplicated()
	export.selected_reports = _get_reports_between_dates(selected_day, selected_day)

func _on_display_interval_button_pressed() -> void:
	interval_picker.visible = not interval_picker.visible

func _on_interval_picker_new_interval(start: Date, end: Date) -> void:
	interval_start = start.duplicated()
	interval_end = end.duplicated()
	report.set_interval(start, end)
	day_selector.set_interval(start, end)
	interval_control_container.show()
	total_check_button.set_pressed_no_signal(false)
	total_label.hide()
	day_selector.show()


func _on_day_selector_new_day(_old_day: Date, new_day: Date) -> void:
	selected_day = new_day.duplicated()
	report.open_new_day(new_day)
	export.selected_reports = _get_reports_between_dates(selected_day, selected_day)


func _on_total_check_button_toggled(toggled_on: bool) -> void:
	report.total_toggled = toggled_on
	if toggled_on:
		total_label.show()
		day_selector.hide()
		export.selected_reports = _get_reports_between_dates(interval_start, interval_end)
	else:
		total_label.hide()
		day_selector.show()
		export.selected_reports = _get_reports_between_dates(selected_day, selected_day)


func _on_interval_reset_button_pressed() -> void:
	interval_start = selected_day
	interval_end = selected_day
	interval_picker.clear_interval()
	interval_control_container.hide()
	total_label.hide()
	day_selector.show()


func _on_interval_picker_reset_interval() -> void:
	report.clear_interval()
	day_selector.clear_interval()
	
func _get_reports_between_dates(start: Date, end: Date) -> Array[DailyReport]:
	var reports: Array[DailyReport] = [_get_daily_report_or_date(start)]
	var iterator: Date = start.duplicated()
	while iterator.compare(end) < 0:
		iterator = Date.get_next(iterator)
		reports.append(_get_daily_report_or_date(iterator))
		
	return reports
	
func _get_daily_report_or_date(day: Date) -> DailyReport:
	var report: DailyReport = LoadedReports.get_daily_report(day)
	return DailyReport.new(day, []) if report == null else report
