extends Node2D

const PACKED_TRACKING_SCENE: PackedScene = preload("res://src/activities/tracking_view.tscn")
const PACKED_REPORT_SCENE: PackedScene = preload("res://src/report/report_view.tscn")
const PACKED_COMPACT_VIEW_SCENE: PackedScene = preload("res://src/activities/compact_view.tscn")

var tracking_node: TrackingView
var report_node: Node
var compact_view: CompactView

func _ready() -> void:
	if(OS.has_feature("window_decoration")):
		get_window().borderless = false
	tracking_node = PACKED_TRACKING_SCENE.instantiate()
	tracking_node.to_compact_view.connect(_on_to_compact_view)
	%ViewContainer.add_child(tracking_node)

func _on_tracking_button_pressed() -> void:
	if report_node != null:
		report_node.queue_free()
	if tracking_node == null:
		tracking_node = PACKED_TRACKING_SCENE.instantiate()
		tracking_node.to_compact_view.connect(_on_to_compact_view)
		%ViewContainer.add_child(tracking_node)


func _on_report_button_pressed() -> void:
	var accumulator: Accumulator = get_tree().get_first_node_in_group("accumulator")
	if accumulator != null:
		accumulator.store_activites(SelectedDay.selected_day)
	if tracking_node != null:
		tracking_node.queue_free()
	if report_node == null:
		LoadedReports.reload()
		report_node = PACKED_REPORT_SCENE.instantiate()
		%ViewContainer.add_child(report_node)

func _on_to_compact_view():
	%MarginContainer.visible = false
	compact_view = PACKED_COMPACT_VIEW_SCENE.instantiate()
	add_child(compact_view)
	compact_view.return_to_large_view.connect(_on_to_large_view)

func _on_to_large_view():
	compact_view.queue_free()
	var window_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var window_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	get_window().size = Vector2i(window_width, window_height)
	%MarginContainer.visible = true
