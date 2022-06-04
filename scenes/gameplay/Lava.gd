extends Area2D


func _on_Lava_body_entered(body: Node):
	if body.name == "Player":
		body.level_die()
