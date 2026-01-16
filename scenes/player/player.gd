class_name Player
extends CharacterBody2D

signal on_player_is_on_floor
signal on_back_crusher
#borrable?
signal on_player_jump
signal on_player_no_energy

@export var gravity: float = 1000.0
@export var jump_force: float = 450.0
@export var max_speed: float = 400.0
@export var energy_limit: float = 300.0
@export var energy: float = 300.0
@export var energy_loss: float = 5
@export var limit_power_advantage: float = 5

var energy_percentage
var color_screen: String = 'green'

var player_running: bool = false
var trapped = false
var was_on_floor: bool = false

var input_left: bool = true
var input_right: bool = true
var input_jump: bool = true

@onready var anim_screen: AnimatedSprite2D = $screen
@onready var anim_robot: AnimatedSprite2D = $robot
var death_played: bool = false
var has_touched_floor := false

@onready var timer: Timer = $Timer
var is_moving_recently: bool = false

func _physics_process(delta: float) -> void:
	
	if player_running == false:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y , max_speed)
	else:
		input_jump = true
		if not has_touched_floor:
			has_touched_floor = true
			
	if is_on_floor() and (energy > 0 and !trapped):
		if not was_on_floor:
			on_player_is_on_floor.emit()
			was_on_floor = true
			
		if Input.is_action_just_pressed("jump") and input_jump:
			velocity.y -= jump_force
			input_jump = false
			on_player_jump.emit()

		if Input.is_action_just_pressed("left") and input_left:
			calculate_reserves(energy_loss)
			on_back_crusher.emit()
			restart_move_timer()

		elif Input.is_action_just_pressed("right") and input_right:
			calculate_reserves(energy_loss)
			on_back_crusher.emit()
			restart_move_timer()
			
	if energy == 0.0: 
		on_player_no_energy.emit()

	set_color_screen()
	animations_player()
	move_and_slide()

func set_running() -> void:
	player_running = !player_running

func set_trapped():
	trapped = !trapped

func recover_energy(value: float) -> void:
	energy = min(energy + value, energy_limit)
		
func calculate_reserves(less_energy: float) -> void:
	energy -= less_energy
	
	if input_left == true:
		input_left = false
		input_right = true
	else: 
		input_right = false
		input_left = true

func animations_player() -> void:
	if death_played:
		return
	
	if energy == 0:
		set_animation("death")
		death_played = true
		return
	
	if not is_on_floor() and velocity.y > 0 and not has_touched_floor:
		set_animation("jump", false, 3)
		return
	
	if is_on_floor() and (energy > 0 and !trapped):
		if Input.is_action_just_pressed("jump"):
			set_animation("jump")
		elif is_moving_recently:
			set_animation("run")
		else:
			set_animation("idle")
			
func set_animation(anim_name: String, playing: bool = true, frame: int = -1) -> void:
	if playing:
		anim_robot.play(anim_name)
		anim_screen.play(color_screen + "_" + anim_name)
		anim_screen.frame = anim_robot.frame
	else:
		anim_robot.stop()
		anim_screen.stop()
		if frame != -1:
			anim_robot.animation = anim_name
			anim_robot.frame = frame
			anim_screen.animation = color_screen + "_" + anim_name
			anim_screen.frame = frame

func set_color_screen() -> void:
	energy_percentage = (energy / energy_limit) * 100 
	if energy_percentage > 70 and energy_percentage <= 100:
		color_screen = "green"
	elif energy_percentage > 30 and energy_percentage < 69:
		color_screen = "yellow"
	elif energy_percentage > 0 and energy_percentage < 29:
		color_screen = "red"

func restart_move_timer() -> void:
	is_moving_recently = true
	timer.start()

func _on_timer_timeout() -> void:
	is_moving_recently = false
