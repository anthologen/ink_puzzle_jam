extends Area2D


func _on_Lava_body_entered(body: Node):
	if body.name == "Player":
		var params = {"is_win": false}
		Game.change_scene("res://scenes/menu/menu.tscn", params)
