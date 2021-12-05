extends Line2D

export(NodePath) var target_path = get_parent()
export(int) var trail_length = 10

var target

func _ready():
	target = get_node(target_path)

func _process(delta):
	# Reset position
	global_position = Vector2.ZERO
	global_rotation = 0
	
	# Create points
	var point = target.global_position
	add_point(point)
	
	# Keep length
	while get_point_count() > trail_length:
		remove_point(0)
