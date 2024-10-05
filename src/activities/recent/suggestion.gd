extends RichTextLabel
class_name Suggestion

static var SCENE: PackedScene = preload("res://src/activities/recent/Suggestion.tscn")

static var regex: RegEx = RegEx.new()

const FORMAT: String = "[color=#999999]%s[/color][color=white]%s[/color][color=#999999]%s[/color]"
# format this regex, replacing %s with the match to look for. 
# group 2 will be the matched section, group 1 everything before and group 3 everything after
const REGEX_STRING: String = "^(.*?)(%s)(.*?)$"

@export var search_string: String = "":
	set(new):
		search_string = new
		_update_match(new)
		
@export var selected: bool = false:
	set(new):
		selected = new
		if is_instance_valid(highlight):
			highlight.visible = new

@export var activity_name: String = ""

var matched: bool = false
		
@onready var highlight: ColorRect = $Highlight

func _ready() -> void:
	_update_match(search_string)
	highlight.size = size
	highlight.visible = selected

func _update_match(new_match: String) -> void:
	regex.compile(REGEX_STRING % new_match)
	var regex_match: RegExMatch = regex.search(activity_name)
	if is_instance_valid(regex_match):
		text = FORMAT % [regex_match.get_string(1), regex_match.get_string(2), regex_match.get_string(3)]
		matched = true
	else:
		matched = false

func is_matched() -> bool:
	return matched
	
func is_selected() -> bool:
	return selected
