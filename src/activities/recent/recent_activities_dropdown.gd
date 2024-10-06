extends Container
class_name RecentActivitiesDropdown

static var SCENE: PackedScene = preload("res://src/activities/recent/RecentActivitiesDropdown.tscn")

signal suggestion_accepted(suggestion: String)

static var recent_cutoff: int = 10

@onready var suggestions_container: VBoxContainer = $MarginContainer/SuggestionsContainer

var recent_activities: Array[String] = []
var suggestion_nodes: Array[Suggestion] = []

func _ready() -> void:
	_add_unique_activities_from_last_days(recent_cutoff)
	suggestion_nodes = map_suggestions_to_node(recent_activities)
	visible = is_suggestion_displayed()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("accept_suggestion"):
		suggestion_accepted.emit(_find_selected())
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("next_suggestion"):
		get_viewport().set_input_as_handled()
		var suggestions: Array[Node] = suggestions_container.get_children()
		for i in range(suggestions.size()):
			if suggestions[i].is_selected() and i + 1 <= suggestions.size() - 1:
				suggestions[i].selected = false
				suggestions[i+1].selected = true
				return
	elif event.is_action_pressed("previous_suggestion"):
		get_viewport().set_input_as_handled()
		var suggestions: Array[Node] = suggestions_container.get_children()
		for i in range(suggestions.size()):
			if suggestions[i].is_selected() and i - 1 >= 0:
				suggestions[i].selected = false
				suggestions[i-1].selected = true
				
func _new_activities_from_report(report: DailyReport, existing: Array[String]) -> Array[String]:
	var new_arr: Array[String] = []
	for activity: ActivityModel in report.get_activities():
		var activity_name: String = activity.name
		if not activity_name.is_empty() and not (existing.has(activity_name) or new_arr.has(activity_name)):
			new_arr.append(activity_name)
	return new_arr

func _add_unique_activities_from_last_days(cutoff: int) -> void:
	var current_day: Date = Date.current_as_date()
	for i in range(cutoff):
		var report := LoadedReports.get_daily_report(current_day)
		recent_activities.append_array(_new_activities_from_report(report, recent_activities))
		current_day = Date.get_previous(current_day)

func map_suggestions_to_node(suggestions: Array[String]) -> Array[Suggestion]:
	var nodes: Array[Suggestion] = []
	for suggestion in suggestions:
		var new_node: Suggestion = Suggestion.SCENE.instantiate()
		new_node.activity_name = suggestion
		nodes.append(new_node)
	return nodes
	
func on_new_input(input: String) -> void:
	for node: Suggestion in suggestion_nodes:
		node.search_string = input
		if node.is_matched():
			if not is_selection_displayed():
				node.selected = true
			if not node.is_inside_tree():
				suggestions_container.add_child(node)
		else:
			if node.is_inside_tree():
				node.selected = false
				suggestions_container.remove_child(node)
	visible = is_suggestion_displayed()
			
func _find_selected() -> String:
	for node: Suggestion in suggestion_nodes:
		if node.is_selected():
			return node.activity_name
	return suggestion_nodes[0].activity_name if not suggestion_nodes.is_empty() else ""

func is_suggestion_displayed() -> bool:
	return not suggestions_container.get_children().is_empty()

func is_selection_displayed() -> bool:
	for node: Node in suggestions_container.get_children():
		var suggestion: Suggestion = node as Suggestion
		if suggestion.is_selected():
			return true
	return false
