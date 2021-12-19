extends TextureRect

func _ready() -> void:
	$IceFloor/CollisionShape2D.position.x = rect_size.x / 2
	$IceFloor/CollisionShape2D.shape.extents.x = rect_size.x  / 2
