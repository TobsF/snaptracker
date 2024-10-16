extends Node

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Accumulator.store_activites()
		SqliteDatabase.db.close_db()
		get_tree().quit()
