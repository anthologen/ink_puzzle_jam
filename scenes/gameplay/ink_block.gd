tool
extends StaticBody2D

enum BlockType { GRASS, SAND, TOP }
enum InkMode { DRAW, ERASE }

export var ink_value: int setget set_ink_value, get_ink_value
export var ink_max: int setget set_ink_max, get_ink_max
export (BlockType) var block_type: int setget set_block_type, get_block_type

var button_index := -1 setget set_button_index, get_button_index
var ink_mode: int = InkMode.DRAW setget set_ink_mode, get_ink_mode

onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D
onready var template_sprite := $TemplateSprite as Sprite
onready var ink_sprite := $InkSprite as Sprite
onready var ink_material := ink_sprite.material.duplicate() as ShaderMaterial
onready var tween := $Tween as Tween
onready var input_sprite := $InputSprite as Sprite


func _ready():
	ink_sprite.material = ink_material
	_ink_updated()
	_block_type_updated()


func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int):
	# Put debug-only events below
	if not OS.is_debug_build():
		return

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
		collision_layer = 3 if is_drawn() else 2
		collision_mask = 3 if is_drawn() else 2
		ink_sprite.visible = is_drawn()


func is_drawn() -> bool:
	return ink_value == ink_max


func has_ink() -> bool:
	return ink_value > 0


func is_enough_ink_to_draw(ink: int) -> bool:
	return ink_value + ink >= ink_max


func ink_needed() -> int:
	return ink_max - ink_value


func get_ink_texture() -> Texture:
	return ink_sprite.texture


func set_block_type(p_block_type: int) -> void:
	block_type = p_block_type
	_block_type_updated()


func get_block_type() -> int:
	return block_type


func _block_type_updated() -> void:
	if template_sprite and ink_sprite:
		match block_type:
			BlockType.GRASS:
				template_sprite.texture = preload("res://assets/sprites/tile_grass.png")
				ink_sprite.texture = preload("res://assets/sprites/tile_grass_ink.png")
			BlockType.SAND:
				template_sprite.texture = preload("res://assets/sprites/tile_sand.png")
				ink_sprite.texture = preload("res://assets/sprites/tile_sand_ink.png")
			BlockType.TOP:
				template_sprite.texture = preload("res://assets/sprites/tile_top.png")
				ink_sprite.texture = preload("res://assets/sprites/tile_top_ink.png")


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


func set_button_index(p_button_index: int) -> void:
	button_index = p_button_index
	if input_sprite:
		input_sprite.visible = p_button_index >= 0
		input_sprite.frame_coords.x = max(0, button_index)


func get_button_index() -> int:
	return button_index


func set_ink_mode(p_ink_mode: int) -> void:
	ink_mode = p_ink_mode
	if input_sprite:
		input_sprite.frame_coords.y = ink_mode


func get_ink_mode() -> int:
	return ink_mode
