extends Control

enum Objects {NONE=-1, BOUNCE_PAD, FAN, PORTALS}

export(Array, Objects) var objects = [-1, -1, -1, -1, -1]


var open := false


func _ready() -> void:
	if not visible:
		queue_free()
	
	$Panel.rect_position.y = 60
	
	for object in objects:
		match object:
			Objects.NONE:
				break
			
			Objects.BOUNCE_PAD:
				pass
			
			Objects.FAN:
				pass
				
			Objects.PORTALS:
				pass


# Open on hover
func _on_Panel_mouse_entered() -> void:
	open()
	

# Close on mouse exit
func _on_Panel_mouse_exited() -> void:
	close()
		

# Open with click
func _on_Panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		open()


func open() -> void:
	if not open:
		$AnimationPlayer.play("Open")
		open = true

func close() -> void:
	if open:
		$AnimationPlayer.play_backwards("Open")
		open = false
