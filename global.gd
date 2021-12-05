extends Node

var current_level: int = -1
var levels_unloced: int = 1
var stars_earned: int = 2

func go_to_level(level_num: int) -> void:
	Global.current_level = level_num
	get_tree().change_scene("res://Levels/Level%s.tscn" %  level_num)
