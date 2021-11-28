extends Node2D

export var deer_scene: PackedScene

var deer: KinematicBody2D

func _ready() -> void:
	create_deer()
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			create_deer()
	

func create_deer() -> void:
	deer = deer_scene.instance()
	deer.global_position = $DeerPos.global_position
	get_tree().get_root().call_deferred('add_child', deer)
