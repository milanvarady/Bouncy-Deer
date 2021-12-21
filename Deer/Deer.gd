extends RigidBody2D

signal stopped

var in_goal_area := false
var last_pos := Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	sleeping = true
	collision_mask = 0
	collision_layer = 0


func _physics_process(delta: float) -> void:
	if position.distance_to(last_pos) < 1:
		if $StopPatience.is_stopped():
			$StopPatience.start()
	else:
		if not $StopPatience.is_stopped():
			$StopPatience.stop()
		

	last_pos = position


func stop() -> void:
	sleeping = true
	collision_mask = 0
	collision_layer = 0
	
	set_physics_process(false)
	$StopPatience.stop()
	
	emit_signal("stopped", in_goal_area)


func _on_StopPatience_timeout() -> void:
	stop()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	stop()
