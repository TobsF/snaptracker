extends Window
class_name Import

static var SCENE: PackedScene = preload("res://src/report/import/import.tscn")

var file_filter: PackedStringArray = PackedStringArray(["*csv"])

@onready var filepath_edit: LineEdit = %FilepathEdit
@onready var h_box_container: HBoxContainer = $OverlayMargin/VBoxContainer/HBoxContainer
@onready var loading_info_label: Label = $OverlayMargin/VBoxContainer/LoadingInfoLabel
@onready var v_box_container: VBoxContainer = %VBoxContainer

var dialog: FileDialog  

func _on_file_dialog_button_pressed() -> void:
	if is_instance_valid(dialog):
		dialog.queue_free()
	dialog = FileDialog.new()
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.title = "Select a file to import"
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.filters = file_filter
	add_child(dialog)
	dialog.file_selected.connect(_on_file_selected)
	dialog.show()

func _on_file_selected(filepath: String) -> void:
	filepath_edit.text = filepath

func _on_close_requested() -> void:
	queue_free()

func _on_import_button_pressed() -> void:
	var importer: Importer = Importer.new(filepath_edit.text)
	h_box_container.hide()
	loading_info_label.show()
	var result: Importer.Result = importer.import()
	
	if result == Importer.Result.OK:
		GlobalTextTopic.new_temporary_notification.emit("Imported successfully!", 5, false)
		queue_free()
	else:
		loading_info_label.hide()
		h_box_container.show()
		match result:
			Importer.Result.FILE_PATH_ERROR:
				_add_error("Error: Failed to access file.")
			Importer.Result.PARSING_ERROR:
				_add_error("Error: Failed to parse file.")
			_:
				_add_error("General Error.")

func _add_error(text: String) -> void:
	var error: ErrorInfo = ErrorInfo.SCENE.instantiate()
	error.error_text = text
	v_box_container.add_child(error)
