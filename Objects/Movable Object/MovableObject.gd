extends Node2D

export var movable := true
export var rotatable := true
export var snap_size: int = 16
export var rotate_sensitivity := 0.5

var drag := false
var drag_offset := Vector2.ZERO

var is_rotating := false
var last_mouse_pos: Vector2


func _ready() -> void:
	if not movable:
		$Body/Handles/MoveButton.queue_free()
	
	if not rotatable:
		$Body/Handles/RotateButton.queue_free()
		
	$Body/Handles.rect_pivot_offset = $Body/Handles.rect_size/2


func _process(delta: float) -> void:
	if drag:
		var mouse_pos = get_global_mouse_position()
		
		global_position = ((mouse_pos + drag_offset) / snap_size).floor() * snap_size
		
	elif is_rotating:
		var diff = get_global_mouse_position() - last_mouse_pos
		var dir_sign = (position - get_global_mouse_position()).sign()
		
		$Body.rotation_degrees += ((diff.x * dir_sign.y) + (diff.y * -dir_sign.x)) * rotate_sensitivity
		
		last_mouse_pos = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		drag = false
		is_rotating = false


func _on_MoveButton_button_down() -> void:
	if Global.move_phase:
		drag = true
		drag_offset = global_position - get_global_mouse_position()


func _on_MoveButton_button_up() -> void:
#	drag = false
	pass
	
	
func _on_RotateButton_button_down() -> void:
	if Global.move_phase:
		is_rotating = true
		last_mouse_pos = get_global_mouse_position()


func _on_RotateButton_button_up() -> void:
	is_rotating = false
