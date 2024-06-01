extends Node
class_name ActivityTime

var time: int
var percentage_of_daily: float

func _init(init_time: int, init_percentage: float) -> void:
	time = init_time
	percentage_of_daily = init_percentage
