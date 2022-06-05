extends VBoxContainer

var ink_full = preload("res://assets/sprites/tile_heart.png")
var ink_empty = preload("res://assets/sprites/ui_numX.png")


func update_ink(value: int):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = ink_full
		else:
			get_child(i).texture = ink_empty
