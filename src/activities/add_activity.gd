extends Button

@export var target_container: Container

const ACTIVITY_RESOURCE: Resource = preload("res://src/activities/activity.tscn")

func _on_pressed() -> void:
	var activity: Node = ACTIVITY_RESOURCE.instantiate()
	target_container.add_child(activity)
