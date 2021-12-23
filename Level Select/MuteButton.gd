extends TextureButton

var master_sound = AudioServer.get_bus_index("Master")


func _ready() -> void:
	pressed = AudioServer.is_bus_mute(master_sound)


func _on_MuteButton_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(master_sound, true if button_pressed else false)
