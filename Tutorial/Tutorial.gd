extends Node2D

func _ready() -> void:
	$TutorialAnimation.play("Tutorial")
	

func _on_DeerLauncher_drag_start() -> void:
	queue_free()
