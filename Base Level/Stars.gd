extends Control



var star_num: int = 1

func _on_Timer_timeout() -> void:
	if star_num > Global.stars_earned:
		$Timer.stop()
		return
	
	var star: TextureProgress = get_node("Star%s" % star_num)
	
	var tween = Tween.new()
	add_child(tween)
	
	var scale_normal = star.rect_scale
	var scale_increased = scale_normal * 1.3
	
	tween.interpolate_property(star, "value", 0, 100, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(star, "rect_scale", scale_normal, scale_increased, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(star, "rect_scale", scale_increased, scale_normal, 0.6, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.4)
	
	tween.start()
	
	star_num += 1
	
	if star_num > 3:
		$Timer.stop()


func start_animation() -> void:
	$Timer.start()
