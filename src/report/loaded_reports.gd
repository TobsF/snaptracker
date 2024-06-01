extends Node

var _reports: Array[YearlyReport] = []

class MonthlyReport:
	var month: int
	var _daily_reports: Array[DailyReport] = []
	
	func _init(init_month: int) -> void:
		month = init_month
		_daily_reports.resize(32)
	
	func add_daily(daily_report: DailyReport) -> void:
		_daily_reports[daily_report.date.day] = daily_report

	func get_daily(date: Date) -> DailyReport:
		return _daily_reports[date.day] if _daily_reports.size() >= date.day else null

#yearly handles the loading of monthly data
class YearlyReport:
	var year: int
	var _monthly_reports: Array[MonthlyReport] = []
	
	func _init(init_year: int) -> void:
		year = init_year
		_monthly_reports.resize(13)
	
	func _add_monthly(monthly: MonthlyReport) -> void:
		_monthly_reports[monthly.month] = monthly

	func _get_monthly(month: int) -> MonthlyReport:
		return _monthly_reports[month] if _monthly_reports.size() >= month else null
		
	func get_daily(date: Date) -> DailyReport:
		var monthly: MonthlyReport = _get_monthly(date.month)
		if not monthly:
			_add_monthly(read_monthly(date.month, year))
			monthly = _get_monthly(date.month)
		var daily: DailyReport = monthly.get_daily(date)
		if not daily:
			_add_monthly(read_monthly(date.month, year))
		return monthly.get_daily(date)

	func read_monthly(month: int, read_year: int) -> MonthlyReport:
		var monthly: MonthlyReport = MonthlyReport.new(month)
		var monthly_dict: Dictionary = ActivitiesReader.read_monthly_activites(month, read_year)
		
		for day in monthly_dict:
			monthly.add_daily(DailyReport.new(Date.from_key(day), monthly_dict[day]))
		
		return monthly

func get_daily_report(date: Date) -> DailyReport:
	var filtered: Array[YearlyReport] = _reports.filter(func(y: YearlyReport): y.year == date.year)
	var yearly: YearlyReport
	
	if filtered.size() < 1:
		yearly = YearlyReport.new(date.year)
		_reports.append(yearly)
	else:
		yearly = filtered[0]
		
	return yearly.get_daily(date)
	
func reload() -> void:
	_reports.clear()
