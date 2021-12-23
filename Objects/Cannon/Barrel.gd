extends Area2D


export var force := 2000


var deer: RigidBody2D = null


func _on_Barrel_body_entered(body: Node) -> void:
	if body.is_in_group("Deer") and not $ShootAnimation.is_playing():
		body.sleeping = true
		body.global_position = global_position
		body.hide()
		body.set_physics_process(false)

		deer = body
		
		$ShootAnimation.play("Shoot")


func shoot() -> void:
	if deer != null:
		deer.show()
		deer.set_physics_process(true)
		deer.global_position = global_position
		deer.apply_central_impulse(Vector2(force, 0).rotated(global_rotation))
		deer = null
