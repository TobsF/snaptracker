extends Entity
class_name ActivityEntity

static var TABLE_NAME: String = "activities"
static var TABLE_DEFINITION: Dictionary = {
	"id" = {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
	"reportid" = {"data_type": "int", "not_null": true, "foreign_key": "reports.id"},
	"name" = {"data_type": "text", "not_null": true, "default": "UNNAMED"},
	"time" = {"data_type": "int", "not_null": true, "default": 0},
	"displayorder" = {"data_type": "int", "not_null": true, "default": 0}
}

var id: Entity.Id
var reportid: int
var name: String = "UNNAMED"
var time: int = 0
var displayorder: int = 0

static func get_table_name() -> String:
	return TABLE_NAME

static func get_table_definition() -> Dictionary:
	return TABLE_DEFINITION
	
static func from_dictionary(dict: Dictionary) -> ActivityEntity:
	var entity: ActivityEntity = ActivityEntity.new()
	entity.id = Entity.Id.new(dict["id"])
	entity.reportid = dict["reportid"]
	entity.name = dict["name"]
	entity.time = dict["time"]
	entity.displayorder = dict["displayorder"]
	
	return entity

func get_row() -> Dictionary:
	return {
		"id" = null if not is_instance_valid(id) else id.value,
		"reportid" = reportid,
		"name" = name,
		"time" = time,
		"displayorder" = displayorder
	}
