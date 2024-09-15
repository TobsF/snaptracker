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
	_init_tracking_node()
	%ViewContainer.add_child(tracking_node)

func _on_tracking_button_pressed() -> void:
	_update_or_init_tracking()

func _on_report_button_pressed() -> void:
	Accumulator.store_activites()
	if is_instance_valid(tracking_node):
		var activity: Activity = _get_active_activity()
		if is_instance_valid(activity):
			_set_current_tracking(activity)
		tracking_node.queue_free()
	if not is_instance_valid(report_node):
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

func _on_currently_active_hidden(current: Activity) -> void:
	await Accumulator.saved
	_set_current_tracking(current)


func _on_current_tracking_clicked(_current: Activity) -> void:
	if is_instance_valid(report_node):
		_on_tracking_button_pressed()
	elif is_instance_valid(tracking_node):
		tracking_node.free()
		_on_tracking_button_pressed()
		
func _init_tracking_node() -> void:
	tracking_node = PACKED_TRACKING_SCENE.instantiate()
	tracking_node.to_compact_view.connect(_on_to_compact_view)
	tracking_node.currently_active_hidden.connect(_on_currently_active_hidden)
	tracking_node.new_day_selected.connect(_on_new_day_selected)

func _set_current_tracking(current: Activity) -> void:
	current.remove_from_group("activity_tracking")
	current_tracking.set_current(current)
	
func _on_new_day_selected(new_day: Date) -> void:
	var current_activity: Activity = current_tracking.get_current()
	if is_instance_valid(current_activity):
		if current_activity.model.date.compare(new_day) == 0:
			_update_or_init_tracking()
	
func _update_or_init_tracking() -> void:
	SelectedDay.selected_day = Date.current_as_date()
	var activity: Activity = current_tracking.get_current()
	if is_instance_valid(report_node):
		report_node.queue_free()
	if not is_instance_valid(tracking_node):
		if is_instance_valid(activity):
			SelectedDay.selected_day = activity.model.date
		_init_tracking_node()
		%ViewContainer.add_child(tracking_node)
	if is_instance_valid(activity):
		var activity_name := activity.get_activity_name()
		var time := activity.get_allotted_time()
		current_tracking.clear()
		tracking_node.init_active(activity_name, time)
