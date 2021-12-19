extends Area2D


export var force := 2000


var deer: RigidBody2D = null


func _on_Barrel_body_entered(body: Node) -> void:
	if body.is_in_group("Deer"):
		body.sleeping = true
		body.hide()
		deer = body
		shoot()


func shoot() -> void:
	if deer != null:
		deer.show()
		deer.apply_central_impulse(Vector2(0, -force).rotated(global_rotation))
		print(Vector2(0, -force).rotated(global_rotation))
		deer = null
