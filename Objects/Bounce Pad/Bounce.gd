extends StaticBody2D

export var force := 1200

func _on_BounceArea_body_entered(body: Node) -> void:
	if body.is_in_group("Deer"):
		body.apply_central_impulse(Vector2(0, force).rotated(global_rotation))
		print(Vector2(0, force).rotated(global_rotation))

	pass
