extends Entity
class_name ReportEntity

const TABLE_NAME: String = "reports"
const TABLE_DEFINITION: Dictionary[String, Dictionary] = {
	"id" = {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
	"date" = {"data_type":"char(10)", "unique": true,  "not_null": true},
}

var id: Entity.Id
var date: String

static func get_table_name() -> String:
	return TABLE_NAME

static func get_table_definition() -> Dictionary:
	return TABLE_DEFINITION
	
func get_row() -> Dictionary:
	return {
		"id" = null if not is_instance_valid(id) else id.value,
		"date" = date,
	}

static func from_dictionary(dict: Dictionary) -> ReportEntity:
	var entity: ReportEntity = ReportEntity.new()
	entity.id = Entity.Id.new(dict["id"])
	entity.date = dict["date"]
	return entity


func get_date() -> Date:
	return Date.from_key(date)

func set_date(new_date: Date) -> void:
	date = new_date.to_key()
