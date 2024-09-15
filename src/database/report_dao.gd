class_name ReportDao

func _persist_report_entity(report: ReportEntity) -> void:
		SqliteDatabase.db.insert_row(ReportEntity.get_table_name(), report.get_row())
		
func _persist_activity_entity(activity: ActivityEntity, merge: bool = true) -> void:
	if merge and is_instance_valid(_find_activity_entity("id = '%s'" % [activity.id.value])):
		SqliteDatabase.db.update_rows(ActivityEntity.get_table_name(), "id = '%s'" % [activity.id.value], activity.get_row())
	else:
		SqliteDatabase.db.insert_row(ActivityEntity.get_table_name(), activity.get_row())

func _get_report_entity(date: Date) -> ReportEntity:
	var rows: Array = SqliteDatabase.db.select_rows(ReportEntity.get_table_name(), 
		"date = '%s'" % [date.to_key()], ReportEntity.get_table_definition().keys())
	if rows.size() > 1:
		printerr("Error: more than 1 Report found for date: %s" % [date.to_key()])
	elif rows.size() == 0:
		var new_report: ReportEntity = ReportEntity.new()
		new_report.set_date(date)
		_persist_report_entity(new_report)
		return _get_report_entity(date)
	return ReportEntity.from_dictionary(rows[0])

func _find_activity_entity(query: String) -> ActivityEntity:
	var rows: Array = SqliteDatabase.db.select_rows(ActivityEntity.get_table_name(), 
		query , ActivityEntity.get_table_definition().keys())
	if rows.size() > 1:
		printerr("Error: more than 1 Activity found for query: %s" % [query])
	elif rows.is_empty():
		return null
	return ActivityEntity.from_dictionary(rows[0])
	
func _find_activities(report_id: int) -> Array[ActivityEntity]:
	var result: Array[ActivityEntity] = []
	var query_result: Array[Dictionary] = SqliteDatabase.db.select_rows(ActivityEntity.get_table_name(), 
		"reportid = '%s'" % [report_id], ActivityEntity.get_table_definition().keys())
	for activity: Dictionary in query_result:
		result.append(ActivityEntity.from_dictionary(activity))
	return result
	
func _get_report_id(date: Date) -> int:
	return _get_report_entity(date).id.value

func _map(entity: ActivityEntity, date: Date) -> ActivityModel:
	var model: ActivityModel = ActivityModel.new()
	model.activity_id = entity.id.value
	model.date = date
	model.display_order = entity.displayorder
	model.name = entity.name
	model.time_seconds = entity.time
	return model

func _map_to_entity(model: ActivityModel, report_id: int) -> ActivityEntity:
	var entity: ActivityEntity = ActivityEntity.new()
	entity.displayorder = model.display_order
	entity.id = Entity.Id.new(model.activity_id)
	entity.name = model.name
	entity.reportid = report_id
	entity.time = model.time_seconds
	return entity

func add_new_activity(date: Date) -> ActivityModel:
	var report_id: int = _get_report_id(date)
	var existing_activities: Array[ActivityEntity] = _find_activities(report_id)
	var next_order_number: int = 0
	for existing: ActivityEntity in existing_activities:
		if next_order_number <= existing.displayorder:
			next_order_number = existing.displayorder + 1
			
	var new_activity: ActivityEntity = ActivityEntity.new()
	new_activity.reportid = report_id
	new_activity.displayorder = next_order_number
	_persist_activity_entity(new_activity, false)
	
	var persisted_activity: ActivityEntity = _find_activity_entity("displayorder = '%s' and reportid = '%s'" % [next_order_number, report_id])
	
	return _map(persisted_activity, date)
	
func update_activities(model: DailyReport) -> void:
	var report_id: int = _get_report_id(model.date)
	for activity: ActivityModel in model.get_activities():
		_persist_activity_entity(_map_to_entity(activity, report_id), true)
		
func get_report(date: Date) -> DailyReport:
	var report_entity: ReportEntity = _get_report_entity(date)
	var activity_entities: Array[ActivityEntity] = _find_activities(report_entity.id.value)
	var activity_models: Array[ActivityModel] = []
	for entity: ActivityEntity in activity_entities:
		activity_models.append(_map(entity, date))
	return DailyReport.new(report_entity.get_date(), activity_models)

func delete_activity(model: ActivityModel) -> void:
	SqliteDatabase.db.delete_rows(ActivityEntity.get_table_name(), "id = '%s'" % [model.activity_id])
