extends KinematicBody2D
signal ink_changed  # updates GUI

export (int) var ink_max = 100
export (int) var ink_level = 100

export (int) var speed := 1200
export (int) var jump_speed := -1800
export (int) var gravity := 4000

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO

onready var ink_radius := $InkRadius as Area2D


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
	return true


func deposit_player_ink(ink_amount: int):
	# Adds ink_amount to the player's ink reserves.
	# Any ink over max capacity is ignored.
	ink_level = min(ink_max, ink_level + ink_amount)
	print("ink incremented to ", ink_level)
	emit_signal("ink_changed", ink_level)


func _input(event):
	if not OS.is_debug_build():
		return

	if event.is_action_pressed("test_ink_increment"):
		var selected_obj_ink_cost = 10
		deposit_player_ink(selected_obj_ink_cost)
	if event.is_action_pressed("test_ink_decrement"):
		var selected_obj_ink_cost = 20
		withdraw_player_ink(selected_obj_ink_cost)


func get_input():
	var dir := 0.0
	if Input.is_action_pressed("walk_right"):
		dir += 1
	if Input.is_action_pressed("walk_left"):
		dir -= 1
	if dir != 0.0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed


func _on_InkRadius_body_entered(_body):
	var overlapping_bodies := ink_radius.get_overlapping_bodies()
	for i in overlapping_bodies.size():
		if overlapping_bodies[i].has_method("set_button_index"):
			overlapping_bodies[i].set_button_index(i)


func _on_InkRadius_body_exited(body):
	if body.has_method("set_button_index"):
		body.set_button_index(-1)
	var overlapping_bodies := ink_radius.get_overlapping_bodies()
	for i in overlapping_bodies.size():
		if overlapping_bodies[i].has_method("set_button_index"):
			overlapping_bodies[i].set_button_index(i)
