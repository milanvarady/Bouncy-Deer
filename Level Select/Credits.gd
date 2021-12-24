extends Control


func _on_MusicLink_pressed() -> void:
	OS.shell_open("https://www.youtube.com/channel/UCT1ZkP03V18LmOj8zbyP-Dw?")


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Level Select/LevelSelect.tscn")
