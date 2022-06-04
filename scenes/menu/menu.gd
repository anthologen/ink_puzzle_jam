extends Control


func _input(event: InputEvent):
	if event is InputEventKey or event is InputEventMouseButton:
		var params = {
			show_progress_bar = true,
			"a_number": 10,
			"a_string": "Ciao mamma!",
			"an_array": [1, 2, 3, 4],
			"a_dict": {"name": "test", "val": 15},
		}
		Game.change_scene("res://scenes/gameplay/gameplay.tscn", params)
