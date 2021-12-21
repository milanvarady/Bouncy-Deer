extends TileMap

export var icile_scene: PackedScene

var tilemap_merge = TileMapMerge.new()
var rect_list : Array

func _ready():
#	for cellpos in get_used_cells():
#			var cell = get_cellv(cellpos)
#
#			if cell != 0:
#				var object = icile_scene.instance()
#				object.position = map_to_world(cellpos) * scale + cell_size / 2
#				add_child(object)
#				set_cellv(cellpos, -1)
	
	# Build collision edges and add to level collision object
	rect_list = tilemap_merge.merge(self)
	for rect in rect_list:
		var collision_rect := RectangleShape2D.new()
		var tile_size = cell_size
		# For one way collision to work the shape must be horizontal and then rotated to fit position
		collision_rect.set_extents(rect.size * tile_size / 2)
		var collision_shape := CollisionShape2D.new()
		collision_shape.set_shape(collision_rect)
		#collision_shape.one_way_collision = true
		collision_shape.set_position(rect.position * tile_size + collision_rect.extents)
		$MergedCollision.add_child(collision_shape)


#func _draw():
#	#print("Debug Draw")
#	for child in $MergedCollision.get_children():
#		if child is CollisionShape2D:
#			draw_rect(Rect2(child.position - child.shape.extents, child.shape.extents * 2 - Vector2(1, 1)), 0x00FFFF8F)
#			draw_circle(child.position, 4, 0xFF000080)

