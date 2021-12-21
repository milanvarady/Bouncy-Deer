extends Node2D

export(String, "Drag", "Rotate") var animation

func _ready() -> void:
	$TutorialAnimation.play(animation)
	

#func _on_DeerLauncher_drag_start() -> void:
#	queue_free()
