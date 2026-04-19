extends CharacterBody2D

@export var max_speed: float = 400.0
@export var acceleration: float = 600.0
@export var brake_force: float = 800.0
@export var turn_speed: float = 4.0
@export var dodge_strength: float = 300.0
@export var dodge_cooldown: float = 0.5

var current_speed: float = 0.0
var dodge_timer: float = 0.0

func _physics_process(delta: float) -> void:
	_handle_input(delta)
	_move_player(delta)

func _handle_input(delta: float) -> void:
	var forward_input := Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var turn_input := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if forward_input > 0.0:
		current_speed += acceleration * delta
	elif forward_input < 0.0:
		current_speed -= brake_force * delta
	else:
		current_speed = lerp(current_speed, 0.0, 2.0 * delta)

	current_speed = clamp(current_speed, 0.0, max_speed)
	rotation += turn_input * turn_speed * delta

	dodge_timer -= delta
	if Input.is_action_just_pressed("ui_accept") and dodge_timer <= 0.0:
		var side_dir := Vector2.RIGHT.rotated(rotation)
		velocity += side_dir * dodge_strength
		dodge_timer = dodge_cooldown

func _move_player(delta: float) -> void:
	var forward_dir := Vector2.UP.rotated(rotation)
	velocity = forward_dir * current_speed + velocity
