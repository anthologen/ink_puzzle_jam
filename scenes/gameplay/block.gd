tool
extends StaticBody2D

export var ink_value: int setget set_ink_value, get_ink_value
export var ink_max: int setget set_ink_max, get_ink_max

onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D
onready var polygon_2d := $Polygon2D as Polygon2D


func _ready():
	_ink_updated()


# Adds ink to this block
# returns how much ink was left over
func add_ink(ink: int) -> int:
	ink_value += ink
	var overflow = ink_value - ink_max
	ink_value = min(ink_value, ink_max)
	_ink_updated()
	return overflow


# Removes the requested amount of ink
# returns how much ink was actually removed
func remove_ink(ink: int) -> int:
	var remainder := min(ink, ink_value)
	ink_value -= remainder
	_ink_updated()
	return ink


func set_ink_value(p_ink_value: int) -> void:
	ink_value = p_ink_value
	_ink_updated()


func get_ink_value() -> int:
	return ink_value


func set_ink_max(p_ink_max: int) -> void:
	ink_max = p_ink_max
	_ink_updated()


func get_ink_max() -> int:
	return ink_max


func _ink_updated() -> void:
	if collision_shape_2d:
		collision_shape_2d.disabled = ink_value < ink_max
	if polygon_2d:
		polygon_2d.color = Color.gray if collision_shape_2d.disabled else Color.black
