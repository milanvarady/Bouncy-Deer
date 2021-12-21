extends Node2D

signal level_complete
signal drag_start

# Stars based on number of attempts
# [3 stars, 2 stars, 1 star] if less or equal to number
export var stars: PoolIntArray = [5, 8, 12]

export var deer_scene: PackedScene
export var max_drag_distance: float = 80
export var trajectory_max_iter: int = 100
export var trajectory_max_length: int = 300
export var launch_velocity_multiplier: float = 1000

var shots: int = 0
var deer: RigidBody2D
var drag := false
var launch_velocity := Vector2.ZERO
var can_shoot := false

onready var hit_cam: Camera2D = get_parent().get_node("HitCam")
onready var hit_tween: Tween = hit_cam.get_node("HitCamTween")

func _ready() -> void:
	create_deer()
	
	$AimDrag.modulate.a = 0
	

func _process(delta: float) -> void:
	if drag:
		var deer_pos = $DeerPos.position
		
		var mouse_direction = deer_pos.direction_to(get_local_mouse_position())
		var distance_to_mouse = deer_pos.distance_to(get_local_mouse_position())
		
		$AimDrag.position = deer_pos + mouse_direction * min(distance_to_mouse, max_drag_distance)
		
		update_trajectory()
		

# Start drag
func _on_AimDrag_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag") and deer != null and can_shoot:
		drag = true
		
		emit_signal("drag_start")
		
		$AimDrag.modulate.a = 1
		$Trajectory.show()

# Launch deer
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("drag") and drag:
		drag = false
		can_shoot = false
		Global.move_phase = false
		
		launch_velocity = calculate_launch_velocity()
		
		shots += 1
		
		deer.position = $DeerPos.position
		
		# Reset Trajectory and AimDrag
		$Trajectory.hide()
		$AimDrag.modulate.a = 0
		$AimDrag.position = $DeerPos.position
		
		# Camera zoom animation
		var zoom_in_duration := 0.5
		var delay := 0.4
		var zoom_out_duration := 0.3
		var start_pos: Vector2 = hit_cam.global_position
		var end_pos: Vector2 = $DeerPos.global_position
		var zoom_scale := Vector2(0.2, 0.2)
		
		# Zoom in animation
		hit_cam.make_current()
		
		hit_tween.interpolate_property(hit_cam, "zoom", Vector2.ONE, zoom_scale, zoom_in_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		hit_tween.interpolate_property(hit_cam, "global_position", start_pos, end_pos, zoom_in_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		hit_tween.interpolate_callback($AnimatedSprite, zoom_in_duration, "play", "Hit")
		hit_tween.interpolate_callback($WhooshSound, zoom_in_duration, "play")
		
		# Zoom out
		hit_tween.interpolate_property(hit_cam, "zoom", zoom_scale, Vector2.ONE, zoom_out_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, zoom_in_duration + delay)
		hit_tween.interpolate_property(hit_cam, "global_position", end_pos, start_pos, zoom_out_duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, zoom_in_duration + delay)
			
		hit_tween.start()

func _on_HitCamTween_tween_all_completed() -> void:
	hit_cam.clear_current()
	
	deer.sleeping = false
	deer.set_physics_process(true)
	deer.collision_mask = 1
	deer.collision_layer = 1
	
	deer.apply_central_impulse(launch_velocity)
	deer.get_node('Trail').set_process(true)
	
	$Timeout.start()
	$HitSound.play()


func _on_Deer_stopped(in_goal):
	deer.disconnect("stopped", self, "_on_Deer_stopped")
	
	if in_goal:
		if Global.current_level == Global.levels_unloced:
			Global.levels_unloced += 1

		# Calculate stars
		for i in stars.size():
			if shots <= stars[i]:
				Global.stars_earned = 3 - i
				break
			elif i == 2:
				Global.stars_earned = 0

		emit_signal("level_complete")

		# Disable stuck help
		$Timeout.stop()
		$StuckPopup.hide()
	else:
		create_deer()


func create_deer() -> void:
	Global.move_phase = true
	
	deer = deer_scene.instance()
	
	deer.position = $DeerPos.position
	deer.connect("stopped", self, "_on_Deer_stopped")
	
	call_deferred("add_child", deer)
	
	$StuckPopup.hide()
	$Timeout.stop()
	
	can_shoot = true


func update_trajectory(delta: float = 0.016):
	$Trajectory.clear_points()
	var vel = calculate_launch_velocity().round()
	
	var pos: Vector2 = $DeerPos.position
	var last_pos: Vector2 = pos
	var distance := 0.0
	var grav = ProjectSettings.get_setting("physics/2d/default_gravity") * deer.gravity_scale
	
	$Trajectory.add_point(pos)
	
#	for i in trajectory_max_iter:
#		var x = pos.x + vel.x * delta
#		var y = pos.y + vel.y * delta - (grav * pow(delta, 2.0)) / 2.0
#
#		pos = Vector2(x, y)
#
#		$Trajectory.add_point(pos)
	
	for i in trajectory_max_iter:
		vel.y += grav * delta

		pos += vel * delta

		distance += pos.distance_to(last_pos)

		if distance > trajectory_max_length:
			break

		$Trajectory.add_point(pos)

		last_pos = pos


func calculate_launch_velocity() -> Vector2:
	return (($DeerPos.position - $AimDrag.position) / max_drag_distance) * launch_velocity_multiplier


func _on_Timeout_timeout() -> void:
	$StuckPopup.show()


func _on_StuckButton_pressed() -> void:
	deer.stop()
	$StuckPopup.hide()


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "Hit":
		$AnimatedSprite.play("Idle")

