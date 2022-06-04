extends Area2D

export (String, FILE, "*.tscn") var exit


func _on_Door_body_entered(body: Node):
	if body.name == "Player":
		body.level_win(exit)

