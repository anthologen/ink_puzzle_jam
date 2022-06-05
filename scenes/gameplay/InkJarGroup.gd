extends HBoxContainer

const InkJar = preload("res://scenes/gameplay/InkJar.tscn")

export (int) var ink_max = 3
export (int) var ink_level = 2


func _init():
	for idx in ink_max:
		if idx < ink_level:
			add_child(InkJar.instance(true))
		else:
			add_child(InkJar.instance(false))


func update_ink_jars():
	pass
