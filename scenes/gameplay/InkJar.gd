extends CenterContainer


func add_ink() -> bool:
	if has_ink():
		return false
	$JarInk.visible = true
	return true


func withdraw_ink() -> bool:
	if not has_ink():
		return false
	$JarInk.visible = false
	return true


func has_ink() -> bool:
	return $JarInk.visible
