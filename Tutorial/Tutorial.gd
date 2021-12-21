extends Node2D

export(String, "Drag", "Rotate", "Dock") var animation = "Drag"

func _ready() -> void:
	$TutorialAnimation.play(animation)
