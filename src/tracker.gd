extends Node2D

const PACKED_TRACKING_SCENE: PackedScene = preload("res://src/activities/tracking_view.tscn")
const PACKED_REPORT_SCENE: PackedScene = preload("res://src/report/report_view.tscn")

var tracking_node: Node
var report_node: Node

func _ready() -> void:
	if(OS.has_feature("window_decoration")):
		get_window().borderless = false
	tracking_node = PACKED_TRACKING_SCENE.instantiate()
	%ViewContainer.add_child(tracking_node)

func _on_tracking_button_pressed() -> void:
	if report_node != null:
		report_node.queue_free()
	if tracking_node == null:
		tracking_node = PACKED_TRACKING_SCENE.instantiate()
		%ViewContainer.add_child(tracking_node)


func _on_report_button_pressed() -> void:
	if tracking_node != null:
		tracking_node.queue_free()
	if report_node == null:
		report_node = PACKED_REPORT_SCENE.instantiate()
		%ViewContainer.add_child(report_node)
