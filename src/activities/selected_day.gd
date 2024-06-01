extends Node

@onready var selected_day: Dictionary = Time.get_date_dict_from_system(true)

func as_date() -> Date:
	return Date.new(int(selected_day["day"]), int(selected_day["month"]), int(selected_day["year"]))
