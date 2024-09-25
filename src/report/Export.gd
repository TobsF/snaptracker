extends HBoxContainer
class_name CsvExport

var selected_reports: Array[DailyReport]

const CSV_SEPARATOR: String = ';'
const LINE_SEPARATOR: String = '\n'
const CSV_HEADER_LINE: int = 0

@onready var export_buttons_container: HBoxContainer = $VBoxContainer/ExportButtonsContainer


func _on_export_pressed() -> void:
	export_buttons_container.visible = not export_buttons_container.visible


func _on_csv_export_button_pressed() -> void:
	var file = FileAccess.open("user://export.csv", FileAccess.WRITE)
	file.store_string(_create_csv_string(selected_reports))
	GlobalTextTopic.new_temporary_notification.emit("Saved to " + file.get_path_absolute() + ".", 5, true)
	file.close()



func _on_clipboard_export_button_pressed() -> void:
	DisplayServer.clipboard_set(_create_csv_string(selected_reports))
	GlobalTextTopic.new_temporary_notification.emit("Saved to clipboard.", 2, true)

func _create_csv_string(reports: Array[DailyReport]) -> String:
	var csv_lines: Array[String] = [';']
	var activity_position: Dictionary = {}
	var columns: int = 1

	for report: DailyReport in reports:
		csv_lines[CSV_HEADER_LINE] += _get_date_header_string(report)
		for activity: ActivityModel in report.get_activities():
			var formatted_time: String = TimeFormatter.format(report.get_time_for_activity(activity).time)
			if activity_position.has(activity.name):
				csv_lines[activity_position.get(activity.name)] += formatted_time
			else:
				activity_position[activity.name] = csv_lines.size()
				var new_line = _sanitize(activity.name) + CSV_SEPARATOR.repeat(columns) + formatted_time
				csv_lines.append(new_line)
		columns += 1
		_append_separator(csv_lines)
	return csv_lines.reduce(func(accum, next_line): return accum + LINE_SEPARATOR + next_line, "")

func _get_date_header_string(report: DailyReport) -> String:
	# TODO maybe i18n
	return report.date.to_key()
	
func _append_separator(csv_lines: Array[String]) -> void:
	var i := 0
	for line: String in csv_lines:
		csv_lines[i] += CSV_SEPARATOR
		i += 1
	
func _sanitize(input: String) -> String:
	if input.contains(CSV_SEPARATOR):
		return '"' + input + '"'
	return input
