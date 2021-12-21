extends Area2D


func _ready() -> void:
	$AnimatedSprite.play("Flow")


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Deer"):
		body.gravity_scale *= -1
		$SwitchSound.play()
