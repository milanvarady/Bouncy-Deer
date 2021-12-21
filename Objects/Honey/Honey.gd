extends TextureRect

func _ready() -> void:
	var shape := RectangleShape2D.new()
	
	shape.extents = Vector2(rect_size.x / 2, 3)
	
	$Area2D/CollisionShape2D.shape = shape
	$Area2D/CollisionShape2D.position.x = rect_size.x / 2


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Deer"):
		body.stop()
