extends Button

func _ready() -> void:
	if(OS.has_feature("window_decoration")):
		queue_free()

func _process(_delta: float) -> void:
	global_position =  Vector2(get_window().size.x - size.x, 0)

func _on_pressed() -> void:
	var accumulator: Accumulator = get_tree().get_first_node_in_group("accumulator")
	if accumulator != null:
		accumulator.store_activites(SelectedDay.selected_day)
	get_tree().quit()
