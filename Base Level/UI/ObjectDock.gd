extends Control

export var objects_path: NodePath

var objects_on_dock: Array = []
var mouse_inside := false


func _ready() -> void:	
	# This is because of a bug
	$Dock.rect_size = Vector2(960, 112)
	$Dock/DockAnimation.play_backwards("Open")
	
	var objects_on_dock = false
	
	for object in $Dock.get_children():
		if object.is_in_group("Objects"):
			call_deferred("add_object", object)
			object.position.y = $Dock.rect_size.y / 2
			
			objects_on_dock = true
			
	if not objects_on_dock:
		queue_free()


func _process(delta: float) -> void:
	if Rect2(rect_position, rect_size).has_point(get_global_mouse_position()):
		if not mouse_inside:
			_on_ObjectDock_mouse_entered()
		
		mouse_inside = true
	else:
		if mouse_inside:
			_on_ObjectDock_mouse_exited()
		
		mouse_inside = false


func _on_DragArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("Objects") and not objects_on_dock.has(area):
		if area.drag and not objects_on_dock.has(area):
			add_object(area)


func add_object(area) -> void:
	if Global.move_phase:
#		var before_pos = area.global_position
				
		area.get_node("Body").scale = Vector2(0.5, 0.5)
		
		area.get_parent().remove_child(area)
		$Dock.call_deferred("add_child", area)
	#	area.set_deferred("global_position", before_pos)
		
		objects_on_dock.append(area)


func _on_ObjectDock_mouse_entered() -> void:
	if Global.move_phase:
		$Dock/DockAnimation.play("Open")


func _on_ObjectDock_mouse_exited() -> void:	
	$Dock/DockAnimation.play_backwards("Open")


func _on_DragArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("Objects") and objects_on_dock.has(area):
		area.get_parent().call_deferred("remove_child", area)
		get_node(objects_path).call_deferred("add_child", area)
		
		area.get_node("Body").scale = Vector2.ONE
		
		objects_on_dock.erase(area)
