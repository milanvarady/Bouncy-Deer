extends Control


func _on_MusicLink_pressed() -> void:
	OS.shell_open("https://www.context-sensitive.com/")


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Level Select/LevelSelect.tscn")
