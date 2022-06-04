extends Area2D


func _on_Door_body_entered(body: Node):
	if body.name == "Player":
		var params = {"is_win": true}
		Game.change_scene("res://scenes/menu/menu.tscn", params)
