extends GridContainer

export var lvl_button_scene: PackedScene
export var n_levels: int = 10

func _ready() -> void:
	for i in n_levels:
		var button: Button = lvl_button_scene.instance()
		
		button.text = str(i + 1)
		button.connect('change_level', self, '_on_LvlButton_change_level')
		
		if Global.levels_unloced <= i:
			button.disabled = true
		
		add_child(button)


func _on_LvlButton_change_level(level_num: int) -> void:
	Global.go_to_level(level_num)
