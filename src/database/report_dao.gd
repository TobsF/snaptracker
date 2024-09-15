class_name ReportDao

func persist_report_entity(report: ReportEntity, merge: bool = true) -> void:
	if merge and is_instance_valid(_find_report_entity(report.get_date())):
		SqliteDatabase.db.update_rows(report.get_table_name(), "date = '%s'" % [report.date], report.get_row())
	else:
		SqliteDatabase.db.insert_row(report.get_table_name(), report.get_row())

func _find_report_entity(date: Date) -> ReportEntity:
	var rows: Array = SqliteDatabase.db.select_rows(ReportEntity.get_table_name(), 
		"date = '%s'" % [date.to_key()], ReportEntity.get_table_definition().keys())
	if rows.size() != 1:
		printerr("Error: more than 1 Report found for: %s" % [date.to_key()])
	return ReportEntity.from_dictionary(rows[0])
