extends Control


var objects_on_dock: Array = []
var mouse_inside := false
var initial_collect := 5


func _ready() -> void:
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
		if area.drag or initial_collect > 0:
			area.get_node("Body").scale = Vector2(0.5, 0.5)
			objects_on_dock.append(area)
			
			if initial_collect > 0:
				area.get_node("HideAnimation").play("Hide")


func _on_ExitArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("Objects") and objects_on_dock.has(area):
		area.get_node("Body").scale = Vector2(1, 1)
		
		objects_on_dock.erase(area)


func _on_ObjectDock_mouse_entered() -> void:
	for object in objects_on_dock:
		object.get_node("HideAnimation").play_backwards("Hide")
		
	$Dock/DockAnimation.play("Open")


func _on_ObjectDock_mouse_exited() -> void:
	for object in objects_on_dock:
		if not object.drag:
			object.get_node("HideAnimation").play("Hide")
	
	$Dock/DockAnimation.play_backwards("Open")
