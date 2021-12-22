extends Area2D

onready var particles := $DirectionParticles

func _ready() -> void:
	$AnimatedSprite.play("Flow")


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Deer"):
		body.gravity_scale *= -1
		$SwitchSound.play()
		
		particles.position = position
		particles.global_rotation = 0
		particles.gravity.y = abs(particles.gravity.y) * sign(body.gravity_scale)
		particles.emitting = true
