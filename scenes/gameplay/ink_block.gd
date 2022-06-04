tool
extends StaticBody2D

enum BlockType { SAND }

export var ink_value: int setget set_ink_value, get_ink_value
export var ink_max: int setget set_ink_max, get_ink_max
export (BlockType) var block_type: int setget set_block_type, get_block_type

onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D
onready var template_sprite := $TemplateSprite as Sprite
onready var ink_sprite := $InkSprite as Sprite
onready var ink_material := ink_sprite.material.duplicate() as ShaderMaterial
onready var tween := $Tween as Tween


func _ready():
	ink_sprite.material = ink_material
	_ink_updated()
	_block_type_updated()


func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int):
	var mouse_button := event as InputEventMouseButton
	if mouse_button and mouse_button.pressed:
		if mouse_button.button_index == BUTTON_LEFT:
			prints("Remainder", add_ink(1), "ink")
		if mouse_button.button_index == BUTTON_RIGHT:
			prints("Removed", remove_ink(1), "ink")


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
	var remainder := int(min(ink, ink_value))
	ink_value -= remainder
	_ink_updated()
	return remainder


func set_ink_value(p_ink_value: int) -> void:
	ink_value = p_ink_value
	if ink_value > ink_max:
		ink_max = ink_value
		property_list_changed_notify()
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
		var drawn := ink_value == ink_max
		collision_layer = 1 if drawn else 2
		collision_mask = 1 if drawn else 2
		ink_sprite.visible = drawn


func set_block_type(p_block_type: int) -> void:
	block_type = p_block_type
	_block_type_updated()


func get_block_type() -> int:
	return block_type


func _block_type_updated() -> void:
	if template_sprite and ink_sprite:
		match block_type:
			BlockType.SAND:
				template_sprite.texture = preload("res://assets/sprites/tile_sand.png")
				ink_sprite.texture = preload("res://assets/sprites/tile_sand_ink.png")


func _on_InkSprite_visibility_changed():
	if Engine.editor_hint or not tween:
		ink_material.set_shader_param("percent", 1)
	else:
		if tween.interpolate_method(
			self, "_update_ink_progress", 0.0, 1.0, .5, Tween.TRANS_CUBIC, Tween.EASE_OUT
		):
			tween.start()


func _update_ink_progress(progress: float) -> void:
	ink_material.set_shader_param("percent", progress)
