extends Node
class_name Importer

var filepath: String
var _import_result: Result = Result.OK
var _dao: ReportDao

enum Result {
	OK,
	FILE_PATH_ERROR,
	PARSING_ERROR,
}

func _init(init_filepath: String) -> void:
	filepath = init_filepath
	_dao = ReportDao.new()

func import() -> Importer.Result:
	var file: FileAccess = FileAccess.open(filepath, FileAccess.READ)
	
	if not is_instance_valid(file):
		return Result.FILE_PATH_ERROR
	
	var reports: Array[DailyReportMutable] = _parse_file(file)
	
	if reports.is_empty():
		return Result.PARSING_ERROR
	
	for daily_report: DailyReportMutable in reports:
		_dao.import_report(daily_report)
	
	return _import_result

func _parse_file(file: FileAccess) -> Array[DailyReportMutable]:
	# skip to first non-empty line
	var current_line: PackedStringArray = PackedStringArray([])
	while not _contains_nonempty_line(current_line) and file.get_position() < file.get_length():
		current_line = file.get_csv_line(";")
	
	var mutable_reports: Array[DailyReportMutable] = _header_to_reports(current_line)
	
	while file.get_position() < file.get_length():
		current_line = file.get_csv_line(";")
		if current_line.size() < 2:
			continue
			
		var activity_name = current_line[0]
		
		var index = 0
		for daily_time: String in current_line.slice(1, mutable_reports.size() + 1):
			var selected_report: DailyReportMutable = mutable_reports[index]
			var model: ActivityModel = _time_string_to_activity_model(selected_report.date, activity_name, daily_time)
			if model.time_seconds > 0:
				selected_report.add_activity(model)
			index += 1
	
	return mutable_reports
	
func _header_to_reports(header_line: PackedStringArray) -> Array[DailyReportMutable]:
	var reports: Array[DailyReportMutable] = []
	for value: String in header_line:
		if value.is_empty():
			continue
		reports.append(DailyReportMutable.new(Date.from_key(value)))
	return reports

func _time_string_to_activity_model(date: Date, activity_name: String, time: String) -> ActivityModel:
	var model: ActivityModel = ActivityModel.new()
	model.date = date
	model.name = activity_name
	model.time_seconds = TimeFormatter.parse(time)
	return model

func _contains_nonempty_line(string_array: PackedStringArray) -> bool:
	for string: String in string_array:
		if not string.is_empty():
			return true
	return false
