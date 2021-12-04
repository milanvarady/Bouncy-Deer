extends Sprite

export (int, 20, 80) var fan_speed := 30

var deer: KinematicBody2D = null

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group('Deer'):
		deer = body
		set_process(true)


func _process(delta: float) -> void:
	if deer != null:
		deer.velocity -= Vector2.DOWN.rotated(rotation) * fan_speed


func _on_Area2D_body_exited(_body: Node) -> void:
	deer = null
	set_process(false)
