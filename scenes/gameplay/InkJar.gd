extends Container

export (bool) var is_full = true


func _init(init_is_full: bool):
	print(init_is_full)
	update_ink_jar(init_is_full)


func update_ink_jar(new_is_full: bool):
	is_full = new_is_full
	if is_full:
		$JarInk.visible = true
	else:
		$JarInk.visible = false
