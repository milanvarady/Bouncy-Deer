extends Button

signal change_level

func _on_LvlButton_pressed() -> void:
	emit_signal("change_level", int(text))
