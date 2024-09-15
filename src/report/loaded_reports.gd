extends Node

var _reports: Dictionary = {}

@onready var report_dao: ReportDao = ReportDao.new()

func _ready() -> void:
	Accumulator.saved.connect(purge)

func get_daily_report(date: Date) -> DailyReport:
	if _reports.has(date.to_key()):
		return _reports[date.to_key()]
	else:
		var report: DailyReport = report_dao.get_report(date)
		_reports[date.to_key()] = report
		return report

func reload() -> void:
	_reports.clear()

func purge(day: Date) -> void:
	_reports.erase(day.to_key())
