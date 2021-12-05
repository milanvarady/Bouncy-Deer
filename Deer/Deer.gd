extends KinematicBody2D

signal stopped

export var gravity: float = 1600
export var max_fall_speed: float = 3000
export (float, 0, 1) var dampening: float = 0.3
export (float, 0, 1) var floor_firction: float = 0.02
export var bouncer_multiplier:float = 1.25

var velocity := Vector2.ZERO

var on_floor: bool = false
var was_on_floor: bool = false
var last_pos: Vector2 = position

var in_goal_area: bool = false


func _ready() -> void:
	set_physics_process(false)
	$Trail.set_process(false)


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
			# Bouncing from wall or celing
			if collision_data.collider.name == "Bouncer":
				velocity *= bouncer_multiplier
			else:
				velocity *= 1 - dampening
			
		else:
			# On floor
			velocity *= 1 - floor_firction
			
			if position.distance_to(last_pos) < 0.05:
				stop()
		
	$Sprite.rotation_degrees += velocity.x * 0.01
		
	was_on_floor = on_floor
	last_pos = position


func stop() -> void:
	emit_signal('stopped', in_goal_area)
	set_physics_process(false)
