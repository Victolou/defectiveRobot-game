class_name Player
extends CharacterBody2D

signal on_back_crusher

@export var gravity: float = 1000.0
@export var jump_force: float = 150.0
@export var max_speed: float = 400.0
@export var energy: float = 300.0
@export var power_advantage: float = 0

var input_left: bool = true
var input_right: bool = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y , max_speed)
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= jump_force
	
	if Input.is_action_just_pressed("left") and (input_left and energy > 0):
		calculate_reserves(5, 00.10)
		on_back_crusher.emit()
		
	elif Input.is_action_just_pressed("right") and (input_right and energy > 0):
		calculate_reserves(5, 0.1)
		on_back_crusher.emit()
	
	if power_advantage > 0:
		power_advantage = max(power_advantage - 0.4 * delta, 0)
	
	move_and_slide()

func calculate_reserves(less_energy: float, more_power: float) -> void:
	energy -= less_energy
	power_advantage += more_power
	
	if input_left == true:
		input_left = false
		input_right = true
	else: 
		input_right = false
		input_left = true
