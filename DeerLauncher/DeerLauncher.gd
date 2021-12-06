extends Node2D

signal level_complete

export var deer_scene: PackedScene
export var max_drag_distance: float = 80
export var trajectory_max_iter: int = 100
export var trajectory_max_length: int = 300
export var launch_velocity_multiplier: float = 1000

var deer: KinematicBody2D
var drag := false

func _ready() -> void:
	create_deer()
	

func _process(delta: float) -> void:
	if drag:
		var deer_pos = $DeerPos.position
		
		var mouse_direction = deer_pos.direction_to(get_local_mouse_position())
		var distance_to_mouse = deer_pos.distance_to(get_local_mouse_position())
		
		deer.position = deer_pos + mouse_direction * min(distance_to_mouse, max_drag_distance)
		
		update_trajectory(deer.gravity, delta)
		

# Start drag
func _on_Deer_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"):
		drag = true
		$Trajectory.show()
		

# Launch deer
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("drag") and drag:
		drag = false
		
		# Set velocity and enable physics
		deer.velocity = calculate_launch_velocity()
		deer.set_physics_process(true)
		deer.get_node('Trail').set_process(true)
		deer.disconnect("input_event", self, "_on_Deer_input_event")
		
		# Reset deer position
		deer.position = $DeerPos.position
		
		$Trajectory.hide()
		$Timeout.start()
		
		$AnimatedSprite.play("Hit")


func _on_Deer_stopped(in_goal):
	deer.disconnect('stopped', self, '_on_Deer_stopped')
	
	if in_goal:
		if Global.current_level == Global.levels_unloced:
			Global.levels_unloced += 1
		
		emit_signal("level_complete")
		
		# Disable stuck help
		$Timeout.stop()
		$StuckPopup.hide()
	else:
		create_deer()


func create_deer() -> void:
	deer = deer_scene.instance()
	deer.position = $DeerPos.position
	deer.connect("input_event", self, "_on_Deer_input_event")
	deer.connect("stopped", self, "_on_Deer_stopped")
	add_child(deer)
	
	$StuckPopup.hide()
	$Timeout.stop()


func update_trajectory(gravity, delta: float):
	$Trajectory.clear_points()
	var vel = calculate_launch_velocity()
	
	var pos: Vector2 = deer.position
	var last_pos: Vector2 = pos
	var distance := 0.0
	
	$Trajectory.add_point(pos)
	
	for i in trajectory_max_iter:
		vel.y += gravity * delta
		
		pos += vel * delta
		
		distance += pos.distance_to(last_pos)
		
		if distance > trajectory_max_length:
			break
			
		$Trajectory.add_point(pos)
		
		last_pos = pos


func calculate_launch_velocity() -> Vector2:
	return (($DeerPos.position - deer.position) / max_drag_distance) * launch_velocity_multiplier


func _on_Timeout_timeout() -> void:
	$StuckPopup.show()


func _on_StuckButton_pressed() -> void:
	deer.stop()
	$StuckPopup.hide()


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "Hit":
		$AnimatedSprite.play("Idle")
