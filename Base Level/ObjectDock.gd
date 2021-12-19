extends Control

export var objects_path: NodePath

var objects_on_dock: Array = []
var mouse_inside := false
var initial_collect := 5
var area_just_added := false


func _ready() -> void:
	if not visible:
		queue_free()
	
	# This is because of a bug
	$Dock.rect_size = Vector2(960, 112)
	$Dock/DockAnimation.play_backwards("Open")


func _process(delta: float) -> void:
	if Rect2(rect_position, rect_size).has_point(get_global_mouse_position()):
		if not mouse_inside:
			_on_ObjectDock_mouse_entered()
		
		mouse_inside = true
	else:
		if mouse_inside:
			_on_ObjectDock_mouse_exited()
		
		mouse_inside = false
		
	if initial_collect > 0:
		initial_collect -= 1


func _on_DragArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("Objects") and not objects_on_dock.has(area):
		if (area.drag or initial_collect > 0) and not objects_on_dock.has(area):
			area.get_node("Body").scale = Vector2(0.5, 0.5)
			
			area.get_parent().remove_child(area)
			$Dock.call_deferred("add_child", area)
			
			area_just_added = true
			
			objects_on_dock.append(area)


func _on_ObjectDock_mouse_entered() -> void:
	$Dock/DockAnimation.play("Open")


func _on_ObjectDock_mouse_exited() -> void:	
	$Dock/DockAnimation.play_backwards("Open")


func _on_DragArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("Objects") and objects_on_dock.has(area):
		area.get_parent().call_deferred("remove_child", area)
		get_node(objects_path).call_deferred("add_child", area)
		
		area.get_node("Body").scale = Vector2.ONE
		
		objects_on_dock.erase(area)
