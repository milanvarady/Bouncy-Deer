extends Path2D

func _ready() -> void:
	for child in get_children():
		if child.is_in_group('Objects'):
			remove_child(child)
			$PathFollow2D.add_child(child)
			child.set_owner($PathFollow2D)
			child.position = Vector2.ZERO
	
	$AnimationPlayer.play("Slide")
