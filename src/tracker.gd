extends Node2D

const PACKED_TRACKING_SCENE: PackedScene = preload("res://src/activities/tracking_view.tscn")
const PACKED_REPORT_SCENE: PackedScene = preload("res://src/report/report_view.tscn")
const PACKED_COMPACT_VIEW_SCENE: PackedScene = preload("res://src/activities/compact_view.tscn")

@onready var current_tracking: CurrentTracking = %CurrentTracking

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
	SelectedDay.selected_day = Date.current_as_date()
	if report_node != null:
		report_node.queue_free()
	if tracking_node == null:	
		var activity: Activity = current_tracking.get_current()
		if activity:
			SelectedDay.selected_day = activity.date
		tracking_node = PACKED_TRACKING_SCENE.instantiate()
		tracking_node.to_compact_view.connect(_on_to_compact_view)
		%ViewContainer.add_child(tracking_node)
		if activity:
			var activity_name := activity.get_activity_name()
			var time := activity.get_allotted_time()
			current_tracking.clear()
			tracking_node.init_active(activity_name, time)

func _on_report_button_pressed() -> void:
	Accumulator.store_activites()
	if tracking_node != null:
		var activity: Activity = _get_active_activity()
		if activity:
			current_tracking.set_current(activity)
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

func _get_active_activity() -> Activity:
	for activity: Activity in get_tree().get_nodes_in_group("activity_tracking"):
		if activity.is_active():
			return activity
	return null
