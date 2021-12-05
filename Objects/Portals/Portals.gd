extends Node2D

var deer: KinematicBody2D = null
var current_portal: Area2D = null

func _on_EndA_body_entered(body: Node) -> void:
	teleport(body, $EndB)


func _on_EndB_body_entered(body: Node) -> void:
	teleport(body, $EndA)


func _on_EndA_body_exited(_body: Node) -> void:
	if current_portal == $EndA:
		deer = null


func _on_EndB_body_exited(_body: Node) -> void:
	if current_portal == $EndB:
		deer = null
	

func teleport(object, endpoint: Area2D) -> void:
	if deer == null:
		deer = object
		deer.global_position = endpoint.global_position
		current_portal = endpoint
