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


func _ready():
	$Version/GameVersion.text = ProjectSettings.get_setting("application/config/version")
	$Version/GodotVersion.text = "Godot %s" % Engine.get_version_info().string
	Game.play_background_music(preload("res://assets/audio/background.wav"))


func pre_start(params):
	var cur_scene: Node = get_tree().current_scene
	print("Current scene is: ", cur_scene.name, " (", cur_scene.filename, ")")
	print("menu.gd: pre_start() called with params = ")
	if params:
		for key in params:
			var val = params[key]
			printt("", key, val)
	if "is_win" in params:
		var is_win = params["is_win"]
		$VBoxContainer/PlayButton.text = "REPLAY"
		if is_win:
			$CenterContainer/TitleVBox/Message.text = "You Won!"
		else:
			$CenterContainer/TitleVBox/Message.text = "You Lost!"
