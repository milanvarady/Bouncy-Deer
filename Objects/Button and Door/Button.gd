extends Area2D


func _ready() -> void:
	$OpenAnimation.play("RESET")


func _on_Button_body_entered(body: Node) -> void:
	if body.is_in_group('Deer'):
		$OpenAnimation.play("Open")
		disconnect("body_entered", self, "_on_Button_body_entered")
