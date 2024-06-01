extends Button

@export var accumulator: Accumulator

func _ready() -> void:
	if(OS.has_feature("window_decoration")):
		queue_free()

func _process(_delta: float) -> void:
	global_position =  Vector2(get_window().size.x - size.x, 0)

func _on_pressed() -> void:
	accumulator.store_activites(SelectedDay.selected_day)
	get_tree().quit()
