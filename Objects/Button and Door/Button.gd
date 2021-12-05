extends Area2D


func _on_Button_body_entered(body: Node) -> void:
	if body.is_in_group('Deer'):
		activate()
		

func activate() -> void:
	pass
