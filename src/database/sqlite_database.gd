extends Node

const PATH: String = "user://data/snaptracker"
var db: SQLite

func _ready() -> void:
	var setup_required: bool = _should_initialize()
	if setup_required:
		DirAccess.make_dir_absolute("user://data/")
		
	_open_db()
	
	if setup_required:
		_create_schema()

func _open_db() -> void:
	db = SQLite.new()
	db.path = PATH
	db.verbosity_level = SQLite.NORMAL
	db.foreign_keys = true
	db.open_db()

func _should_initialize() -> bool:
	return DirAccess.dir_exists_absolute("user://data") or not FileAccess.file_exists(PATH + ".db")

func _create_schema() -> void:
	db.create_table(ReportEntity.get_table_name(), ReportEntity.get_table_definition())
	db.create_table(ActivityEntity.get_table_name(), ActivityEntity.get_table_definition())
