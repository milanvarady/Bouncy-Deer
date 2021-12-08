extends Object
# Class to optimise Tilemaps by finding and joining Adjacent tiles
# "merge" returns an array of unscaled `Rect2`s (IE cell coordinates in the tilemap NOT cell positions on screen)
# NOTE: Assumes all tiles are square, the same size and fill the entire tile

class_name TileMapMerge

func merge(tilemap : TileMap, exclude_list : Array = []) -> Array:
	var rect_list : Array
	var bottom_right := Vector2(1, 1)
	
	# First get all viable rectangles
	for tile_pos in tilemap.get_used_cells():
		if not (exclude_list.has(tilemap.get_cellv(tile_pos))): # Not in excluded list
			if (tilemap.get_cell(tile_pos.x, tile_pos.y - 1) == TileMap.INVALID_CELL or # has to have at least one gap
				tilemap.get_cell(tile_pos.x, tile_pos.y + 1) == TileMap.INVALID_CELL or
				tilemap.get_cell(tile_pos.x - 1, tile_pos.y) == TileMap.INVALID_CELL or
				tilemap.get_cell(tile_pos.x + 1, tile_pos.y) == TileMap.INVALID_CELL):
				rect_list.append(Rect2(tile_pos, bottom_right))
	print("Before:", rect_list.size())
	rect_list = join_rects_x(rect_list)
	print("After x:", rect_list.size())
	rect_list = join_rects_y(rect_list)
	print("After y:", rect_list.size())
	
	return rect_list

func join_rects_x(rect_list : Array) -> Array:
	var remove := Rect2(0.1, 0.1, 0.1, 0.1) # Flag for array element ot remove. This can never match as all other coords are int
	var found := true
	
	while found:
		found = false
		for pos_0 in range(rect_list.size() - 1, -1, -1):
			var rect_0 : Rect2 = rect_list[pos_0]
			for pos_1 in range(rect_list.size() - 1, -1, -1):
				var rect_1 : Rect2 = rect_list[pos_1]
				if (rect_0.position.x + rect_0.size.x == rect_1.position.x and # Ensure rect0 right edge is the same as rect1 left edge
					rect_0.position.y == rect_1.position.y and # ensure they are the same y pos and height
					rect_0.size.y == rect_1.size.y):
					#print("Merge: ", rect_0, " and ", rect_1)
					rect_list[pos_0].size.x = rect_0.size.x + rect_1.size.x # Expand rect0.x by the x size of rect1
					rect_0 = rect_list[pos_0]
					#print("Result: ", rect_0)
					rect_list[pos_1] = remove # Flag Rect_1 for removal
		# now remove those marked for deletion
		for pos in range(rect_list.size() - 1, 0, -1):
			if rect_list[pos] == remove:
				rect_list.remove(pos)
				found = true

	return rect_list

func join_rects_y(rect_list : Array) -> Array:
	var remove := Rect2(0.1, 0.1, 0.1, 0.1) # Flag for array element ot remove. This can never match as all other coords are int
	var found := true
	
	while found:
		found = false
		for pos_0 in range(rect_list.size() - 1, 0, -1):
			var rect_0 : Rect2 = rect_list[pos_0]
			for pos_1 in range(rect_list.size() - 1, 0, -1):
				var rect_1 : Rect2 = rect_list[pos_1]
				if (rect_0.position.y + rect_0.size.y == rect_1.position.y and # Ensure rect0 right edge is the same as rect1 left edge
					rect_0.position.x == rect_1.position.x and # ensure they are the same y pos and height
					rect_0.size.x == rect_1.size.x):
					#print("Merge: ", rect_0, " and ", rect_1)
					rect_list[pos_0].size.y = rect_0.size.y + rect_1.size.y # Expand rect0.x by the x size of rect1
					rect_0 = rect_list[pos_0]
					#print("Result: ", rect_0)
					rect_list[pos_1] = remove # Flag Rect_1 for removal
		# now remove those marked for deletion
		for pos in range(rect_list.size() - 1, 0, -1):
			if rect_list[pos] == remove:
				rect_list.remove(pos)
				found = true

	return rect_list

