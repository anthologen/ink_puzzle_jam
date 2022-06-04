extends Node2D

const INK_MAX = 100
const INK_MIN = 0
export var ink_level = 100

# TODO: replace with custom image asset
var bar_green = preload("res://assets/sprites/barHorizontal_green.png")

onready var ink_bar = $InkBar
onready var ink_count = $InkCount


func _input(event):
	if event.is_action_pressed("test_ink_increment"):
		ink_level = min(INK_MAX, ink_level + 10)
		print("ink incremented to ", ink_level)
	if event.is_action_pressed("test_ink_decrement"):
		ink_level = max(INK_MIN, ink_level - 10)
		print("ink decremented to ", ink_level)


func _process(_delta):
	ink_count.text = str(ink_level)
	ink_bar.value = ink_level
