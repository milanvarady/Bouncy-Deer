extends Area2D


const out_color := Color.dodgerblue
const in_color := Color.green


func _ready() -> void:
	$AreaMarker.color = out_color
	$AreaMarker.color.a = 0.2


func _on_Goal_body_entered(body: Node) -> void:
	if body.is_in_group('Deer'):
		body.in_goal_area = true
		
		$AreaMarker.color = in_color
		$AreaMarker.color.a = 0.4


func _on_Goal_body_exited(body: Node) -> void:
	if body.is_in_group('Deer'):
		body.in_goal_area = false
		
		$AreaMarker.color = out_color
		$AreaMarker.color.a = 0.2


func _on_DeerLauncher_level_complete(_deer_launched, _elapsed_time) -> void:
	$Confetti.emitting = true
	$SuccessSound.play()
