extends TextureRect

func _ready() -> void:
	var shape := RectangleShape2D.new()
	
	shape.extents = Vector2(rect_size.x / 2, 8.5)
	
	$StaticBody2D/CollisionShape2D.shape = shape
	$StaticBody2D/CollisionShape2D.position = rect_size / 2
