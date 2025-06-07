class_name Player
extends CharacterBody2D

signal on_player_is_on_floor
signal on_back_crusher
signal on_player_no_energy

@export var gravity: float = 1000.0
@export var jump_force: float = 450.0
@export var max_speed: float = 400.0
@export var energy_limit: float = 300.0
@export var energy: float = 300.0
@export var energy_loss: float = 5
@export var power_advantage: float = 0
@export var limit_power_advantage: float = 5

var player_running: bool = false
var reached = false
var was_on_floor: bool = false

var input_left: bool = true
var input_right: bool = true

func _physics_process(delta: float) -> void:
	
	if player_running == false:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y , max_speed)
	
	if is_on_floor() and (energy > 0 and !reached):
		if not was_on_floor:
			on_player_is_on_floor.emit()
			was_on_floor = true
			
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_force
		
		if Input.is_action_just_pressed("left") and input_left:
			calculate_reserves(energy_loss, 0.1)
			on_back_crusher.emit()
			
		elif Input.is_action_just_pressed("right") and input_right:
			calculate_reserves(energy_loss, 0.1)
			on_back_crusher.emit()
			
	if energy == 0.0: 
		on_player_no_energy.emit()

	if power_advantage > 0:
		power_advantage = max(power_advantage - 0.5 * delta, 0)
		
	move_and_slide()

func set_running() -> void:
	player_running = !player_running

func set_reached():
	reached = !reached

func set_power_advantage(value: float):
	power_advantage = value

func recover_energy(value: float) -> void:
	energy = min(energy + value, energy_limit)
		
func calculate_reserves(less_energy: float, more_power: float) -> void:
	energy -= less_energy
	if power_advantage < limit_power_advantage:
		power_advantage += more_power
		
	if power_advantage > limit_power_advantage:
		power_advantage = limit_power_advantage
		
	if input_left == true:
		input_left = false
		input_right = true
	else: 
		input_right = false
		input_left = true
