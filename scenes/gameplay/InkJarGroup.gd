extends HBoxContainer

const InkJar = preload("res://scenes/gameplay/InkJar.tscn")


func _init(ink_level: int, ink_max: int):
	for idx in ink_max:
		if idx < ink_level:
			add_child(InkJar.instance(true))
		else:
			add_child(InkJar.instance(false))


func get_ink_level() -> int:
	var ink_level := 0
	for jar in get_children():
		if jar.has_ink():
			ink_level += 1
	return ink_level
