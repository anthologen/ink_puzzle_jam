extends HBoxContainer

const InkJar = preload("res://scenes/gameplay/InkJar.tscn")


func _init(ink_level: int, ink_max: int):
	print("creating ink jars with ", ink_level, "/", ink_max, " inks")
	for idx in ink_max:
		var jar := InkJar.instance()
		if idx < ink_level:
			jar.add_ink()
		add_child(jar)


func get_ink_level() -> int:
	var ink_level := 0
	for jar in get_children():
		if jar.has_ink():
			ink_level += 1
	return ink_level
