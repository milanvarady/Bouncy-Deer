extends Area2D

export (int) var fan_speed := 40

var deer: RigidBody2D = null


func _process(delta: float) -> void:
	if deer != null:
		if not deer.sleeping:
			deer.apply_central_impulse(Vector2.UP.rotated(rotation) * fan_speed)


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group('Deer'):
		deer = body
		set_process(true)


func _on_Area2D_body_exited(_body: Node) -> void:
	deer = null
	set_process(false)
