extends AnimatedSprite

func _ready() -> void:
	playing = true
	$AnimationPlayer.play("Spin")
