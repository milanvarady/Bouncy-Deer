extends Control


export var last_level := false


func _ready() -> void:
	hide()
	
	if last_level:
		$Panel/ButtonContainer/NextLevel.queue_free()


func _on_BackToMenu_pressed() -> void:
	MusicController.set_effect("menu")
	get_tree().change_scene('res://Level Select/LevelSelect.tscn')


func _on_NextLevel_pressed() -> void:
	Global.go_to_level(Global.current_level + 1)


func _on_DeerLauncher_level_complete() -> void:
	$AnimationPlayer.play("LevelComplete")
