class_name Entity

class Id:
	var value: int
	
	func _init(init_value: int):
		value = init_value

static func get_table_name() -> String:
	print("Error: get_table_name must be overridden!")
	return ""

static func get_table_definition() -> Dictionary:
	print("Error: get_table_definition must be overridden!")
	return {}

static func from_dictionary(dict: Dictionary) -> Entity:
	print("Error: from_dictionary must be overridden!")
	return Entity.new()

func get_row() -> Dictionary:
	print("Error: get_row must be overridden!")
	return {}
