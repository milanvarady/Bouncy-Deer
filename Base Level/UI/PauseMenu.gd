extends Control


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused


func _on_Resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_Menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Level Select/LevelSelect.tscn")
	MusicController.set_effect("menu")
