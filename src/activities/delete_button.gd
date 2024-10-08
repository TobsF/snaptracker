extends BoxContainer

signal deleted

@onready var deletion_sprite: Sprite2D = %DeletionSprite
@onready var delete_button: TextureButton = $DeleteButton

var delete_released: bool = false
var deletion_counter: int = 0

func _ready() -> void:
	deletion_sprite.global_position = delete_button.global_position + Vector2(58, 22)

func _on_delete_button_button_down() -> void:
	_increase_deletion_counter()

func _increase_deletion_counter():
	if delete_released:
		deletion_counter = 0
		delete_released = false
		deletion_sprite.scale.y = 0
	elif deletion_counter >= 10:
		deleted.emit()
	else:
		deletion_counter += 1
		var tween: Tween = create_tween()
		tween.tween_property(deletion_sprite, "scale:y", deletion_sprite.scale.y + 0.10 , 0.1)
		tween.parallel().tween_callback(_increase_deletion_counter).set_delay(0.1)

func _on_delete_button_button_up() -> void:
	delete_released = true
