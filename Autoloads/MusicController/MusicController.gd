extends AudioStreamPlayer


var path := "res://Autoloads/MusicController/"
var music_list := ["aiming_high.mp3", "auto-reverse.wav", "contemplation.wav", "portlight.wav"]
var current_track := 0


func _ready() -> void:
	randomize()
	music_list.shuffle()
	
	next_track()
	
	set_effect("menu")
	play()
	

func _on_MusicController_finished() -> void:
	next_track()


func next_track() -> void:
	stream = load(path + music_list[current_track])
	current_track = (current_track + 1) % music_list.size()
	play()


func set_effect(mode):
	AudioServer.set_bus_effect_enabled(1, 0, true if mode == "menu" else false)
	AudioServer.set_bus_effect_enabled(1, 1, true if mode == "paused" else false)
	
