extends Area2D


func _on_Goal_body_entered(body: Node) -> void:
	if body.is_in_group('Deer'):
		body.in_goal_area = true


func _on_Goal_body_exited(body: Node) -> void:
	if body.is_in_group('Deer'):
		body.in_goal_area = false
