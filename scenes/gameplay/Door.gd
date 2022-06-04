extends Area2D

export (String, FILE, "*.tscn") var exit


func _on_Door_body_entered(body: Node):
	if body.name == "Player":
		var params = {"is_win": true}
		Game.change_scene(exit if exit else "res://scenes/menu/menu.tscn", params)
