extends RigidBody2D

signal stopped

var in_goal_area := false
var last_pos := position


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if position.distance_to(last_pos) < 0.1:
		stop()

	last_pos = position


func stop() -> void:
	sleeping = true
	set_process(false)
	
	emit_signal("stopped", in_goal_area)
