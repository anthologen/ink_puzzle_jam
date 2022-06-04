extends Node2D

# TODO: replace with custom image asset
var bar_green = preload("res://assets/sprites/barHorizontal_green.png")

onready var ink_bar = $InkBar
onready var ink_count = $InkCount


func update_ink(new_ink_value: int):
	ink_count.text = str(new_ink_value)
	ink_bar.value = new_ink_value


func _on_Player_ink_changed(ink_level: int):
	update_ink(ink_level)
