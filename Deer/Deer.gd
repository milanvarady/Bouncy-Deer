extends KinematicBody2D

export var max_drag_distance: float = 80
export var launch_velocity_multiplier: float = 1000
export var gravity: float = 800
export var max_fall_speed: float = 2000
export (float, 0, 1) var dampening: float = 0.2
export (float, 0, 1) var floor_firction: float = 0.02

var velocity := Vector2.ZERO

var on_floor: bool = false
var was_on_floor: bool = false

var base_pos: Vector2
var drag: bool = false


func _ready() -> void:
	set_physics_process(false)
	base_pos = position
	
	
func _process(delta: float) -> void:
	if drag:
		var mouse_direction = base_pos.direction_to(get_global_mouse_position())
		var distance_to_mouse = base_pos.distance_to(get_global_mouse_position())
		
		position = base_pos + mouse_direction * min(distance_to_mouse, max_drag_distance)
		
		update_trajectory(calculate_launch_velocity(), gravity, delta)


func _physics_process(delta: float) -> void:
	# Update on floor
	on_floor = $FloorCheck.is_colliding()
	
	# Apply gravity
	velocity.y = clamp(velocity.y + gravity * delta, -max_fall_speed, max_fall_speed)
		
	var collision_data = move_and_collide(velocity * delta)
	
	# Bounce
	if collision_data:
		velocity = velocity.bounce(collision_data.normal)
		
		if not on_floor or (on_floor and not was_on_floor):
			velocity *= 1 - dampening
		else:
			velocity *= 1 - floor_firction
		
	was_on_floor = on_floor


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("drag") and drag:
		drag = false
		set_process(false)
		velocity = calculate_launch_velocity()
		print(velocity)
		set_physics_process(true)
		$Trajectory.hide()
		$Trajectory.queue_free()


func _on_Deer_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"):
		drag = true


func calculate_launch_velocity() -> Vector2:
	return ((base_pos - position) / max_drag_distance) * launch_velocity_multiplier

		
func update_trajectory(velocity: Vector2, gravity: float, delta: float) -> void:
	$Trajectory.clear_points()
	
	var pos = base_pos
	
	for i in 50:
		$Trajectory.add_point(pos)
		velocity.y =+ gravity * delta
		pos += velocity * delta
		
		
