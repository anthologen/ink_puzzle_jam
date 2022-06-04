extends KinematicBody2D
signal ink_changed  # updates GUI

const Erase := preload("res://scenes/gameplay/erase.tscn")

export (int) var ink_max = 100
export (int) var ink_level = 100

export (int) var speed := 1200
export (int) var jump_speed := -1800
export (int) var gravity := 4000

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO

onready var ink_radius := $InkRadius as Area2D
onready var animation_tree := $AnimationTree as AnimationTree
onready var body_sprite := $BodySprite as Sprite


func _ready():
	emit_signal("ink_changed", ink_level)


func withdraw_player_ink(ink_amount: int) -> bool:
	# Withdraw ink_amount from player's ink reserves.
	# Returns true if player had sufficient ink, false otherwise
	if ink_amount > ink_level:
		return false
	ink_level = ink_level - ink_amount
	print("ink decremented to ", ink_level)
	emit_signal("ink_changed", ink_level)
	$fx/draw.play()
	return true


func deposit_player_ink(ink_amount: int):
	# Adds ink_amount to the player's ink reserves.
	# Any ink over max capacity is ignored.
	ink_level = min(ink_max, ink_level + ink_amount)
	print("ink incremented to ", ink_level)
	emit_signal("ink_changed", ink_level)
	$fx/erase.play()


func _is_num(key_event: InputEventKey) -> bool:
	return (
		(KEY_0 <= key_event.scancode and key_event.scancode <= KEY_9)
		or (KEY_KP_0 <= key_event.scancode and key_event.scancode <= KEY_KP_9)
	)


func _get_num(key_event: InputEventKey) -> int:
	if KEY_0 <= key_event.scancode and key_event.scancode <= KEY_9:
		return key_event.scancode - KEY_0
	if KEY_KP_0 <= key_event.scancode and key_event.scancode <= KEY_KP_9:
		return key_event.scancode - KEY_KP_0

	printerr("Unexpected key code: ", key_event.scancode)
	return -1


func _input(event: InputEvent):
	var key_event := event as InputEventKey
	if key_event and key_event.is_pressed() and _is_num(key_event):
		var num := _get_num(key_event) - 1
		if num >= ink_radius.get_overlapping_bodies().size():
			return

		var ink_block = ink_radius.get_overlapping_bodies()[num]
		if ink_block.ink_mode:
			# Draw
			if withdraw_player_ink(ink_block.ink_needed()):
				ink_block.add_ink(ink_block.ink_needed())
				_refresh_ink_radius()
		else:
			# Erase
			deposit_player_ink(ink_block.ink_value)
			ink_block.remove_ink(ink_block.ink_max)
			var erase := Erase.instance()
			erase.texture = ink_block.get_ink_texture()
			add_child(erase)
			erase.global_transform = ink_block.global_transform
			erase.start()
			_refresh_ink_radius()

	# Put debug-only events below
	if not OS.is_debug_build():
		return

	if event.is_action_pressed("test_ink_increment"):
		var selected_obj_ink_cost = 10
		deposit_player_ink(selected_obj_ink_cost)
	if event.is_action_pressed("test_ink_decrement"):
		var selected_obj_ink_cost = 20
		withdraw_player_ink(selected_obj_ink_cost)


func get_input() -> float:
	var dir := 0.0
	if Input.is_action_pressed("walk_right"):
		dir += 1
	if Input.is_action_pressed("walk_left"):
		dir -= 1
	if is_zero_approx(dir):
		velocity.x = lerp(velocity.x, 0, friction)
	else:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	return dir


func _physics_process(delta):
	var dir := get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			animation_tree["parameters/playback"].travel("jump")
			$fx/jump.play()

	if is_zero_approx(velocity.y):
		if is_zero_approx(dir):
			animation_tree["parameters/playback"].travel("idle")
		else:
			body_sprite.scale = Vector2(dir, 1)
			animation_tree["parameters/playback"].travel("walk")
	elif velocity.y > 0:
		animation_tree["parameters/playback"].travel("fall")


func _on_InkRadius_body_entered(_body):
	_refresh_ink_radius()


func _on_InkRadius_body_exited(body):
	if body.has_method("set_button_index"):
		body.set_button_index(-1)
	_refresh_ink_radius()


func _refresh_ink_radius() -> void:
	var overlapping_bodies := ink_radius.get_overlapping_bodies()
	for i in overlapping_bodies.size():
		var overlapping_body = overlapping_bodies[i]
		if overlapping_body.has_method("set_button_index"):
			overlapping_body.set_button_index(-1)
			if overlapping_body.is_drawn():
				if ink_level == ink_max:
					continue  # Cannot hold more ink
				overlapping_body.ink_mode = 0
			else:
				if overlapping_body.is_enough_ink_to_draw(ink_level):
					overlapping_body.ink_mode = 1
				elif overlapping_body.has_ink():
					if ink_level == ink_max:
						continue  # Cannot hold more ink
					overlapping_body.ink_mode = 0
				else:
					continue  # No ink for drawing
			overlapping_body.set_button_index(i + 1)

func level_win(exit = null):
	Game.audio_player.stop()
	$fx/win.play()
	yield($fx/win, "finished")
	var params = {"is_win": true}
	Game.audio_player.play()
	Game.change_scene(exit if exit else "res://scenes/menu/menu.tscn", params)

func level_die():
	Game.audio_player.stop()
	$fx/die.play()
	yield($fx/die, "finished")
	var params = {"is_win": false}
	Game.audio_player.play()
	Game.change_scene("res://scenes/menu/menu.tscn", params)
