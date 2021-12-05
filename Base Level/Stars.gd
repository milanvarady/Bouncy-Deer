extends Control

var star_num: int = 1

func _on_Timer_timeout() -> void:
	if star_num > Global.stars_earned:
		$Timer.stop()
		return
	
	var star: TextureProgress = get_node("Star%s" % star_num)
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(star, "value", 0, 100, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(star, "rect_scale", Vector2(1, 1), Vector2(1.3, 1.3), 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(star, "rect_scale", Vector2(1.3, 1.3), Vector2(1, 1), 0.6, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.4)
	
	tween.start()
	
	star_num += 1
	
	if star_num > 3:
		$Timer.stop()


func start_animation() -> void:
	$Timer.start()


func _on_DeerLauncher_level_complete() -> void:
	start_animation()
