class_name Player
extends CharacterBody2D

signal on_landed_player
signal on_back_crusher
signal on_player_no_energy

signal on_player_limit_advancing
signal on_player_start_advancing
signal on_player_stop_advancing

signal on_player_moves_forward_on_the_stage
signal on_player_has_stopped_on_the_stage
signal on_player_jumps_on_the_stage

@export var gravity: float = 1000.0
@export var jump_force: float = 450.0
@export var max_speed: float = 400.0
@export var energy_limit: float = 300.0
@export var energy: float = 300.0
@export var energy_loss: float = 5
@export var limit_power_advantage: float = 5

#Tiene que ver con el waste para que avance 
var limit_advancing: int = 0

var energy_percentage

var player_running: bool = false
var has_player_landed: bool= false
var has_crashed = false
var was_on_floor: bool = false

var input_left: bool = false
var input_right: bool = true
var input_jump: bool = true

@onready var anim_screen: AnimatedSprite2D = $screen
@onready var anim_robot: AnimatedSprite2D = $robot

var death_played: bool = false
var has_touched_floor: bool = false
var crushed: bool = false

@onready var timer_drop: Timer = $Drop
@onready var timer: Timer = $Timer

var is_moving_recently: bool = false

func _physics_process(delta: float) -> void:
	if player_running == false:
		return
		
	if crushed:
		on_player_has_stopped_on_the_stage.emit()
		death_played = true
		position.y = 360.0
		if has_node("screen"):
			var screen_node = get_node("screen")
			screen_node.queue_free()
		
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y , max_speed)
		if has_player_landed:
			on_player_jumps_on_the_stage.emit()
			on_player_start_advancing.emit()
	else:
		if is_on_floor() and not has_crashed:
			input_jump = true
			
		if not has_touched_floor:
			has_touched_floor = true
			
	if is_on_floor() and (energy > 0 and !crushed) and not death_played:
		if not was_on_floor:
			has_player_landed = true
			on_landed_player.emit()
			was_on_floor = true
			
		if Input.is_action_just_pressed("jump") and input_jump:
			velocity.y -= jump_force
			input_jump = false
			on_player_jumps_on_the_stage.emit()

		if Input.is_action_just_pressed("left") and input_left:
			calculate_reserves(energy_loss)
			restart_move_timer()
			on_back_crusher.emit()
			on_player_start_advancing.emit()
			on_player_moves_forward_on_the_stage.emit()
			limit_advancing +=1

		elif Input.is_action_just_pressed("right") and input_right:
			calculate_reserves(energy_loss)
			restart_move_timer()
			on_back_crusher.emit()
			on_player_start_advancing.emit()
			on_player_moves_forward_on_the_stage.emit()
			limit_advancing +=1
			
		#Reset SOLO si está en el suelo y quieto
		if is_on_floor() and not Input.is_action_just_released("left") and not Input.is_action_just_released("right") and not is_moving_recently:
			on_player_stop_advancing.emit()
			on_player_has_stopped_on_the_stage.emit()
			
		if limit_advancing > 10:
			on_player_limit_advancing.emit()
			limit_advancing = 0
			
	if has_crashed:
		input_left = false
		input_right = false
		input_jump = false
		if timer_drop.is_stopped():
			timer_drop.start()
			timer_drop.wait_time += 0.2
			
	if energy == 0.0: 
		death_played = true
		on_player_stop_advancing.emit()
		on_player_no_energy.emit()
		
	set_color_screen()
	animations_player()
	move_and_slide()

func set_running() -> void:
	player_running = !player_running

func is_crushed():
	crushed = true
		
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
	if crushed:
		anim_robot.play("corpseC")
		return
		
	if energy == 0:
		if anim_robot.animation != "death":
			set_animation("death")
		return
		
	if has_crashed:
		if anim_robot.animation != "drop":
			set_animation("drop")
			return
		
	if not is_on_floor() and velocity.y > 0 and not has_touched_floor and has_crashed == false:
		set_animation("jump", false, 3)
		return
	
	if is_on_floor() and (energy > 0 and !crushed) and has_crashed == false:
		if Input.is_action_just_pressed("jump"):
			set_animation("jump")
		elif is_moving_recently:
			set_animation("run")
		else:
			set_animation("idle")
			
func set_animation(anim_name: String, playing: bool = true, frame: int = -1) -> void:
	if playing:
		anim_robot.play(anim_name)
		anim_screen.play(anim_name)
		anim_screen.frame = anim_robot.frame
	else:
		anim_robot.stop()
		anim_screen.stop()
		if frame != -1:
			anim_robot.animation = anim_name
			anim_robot.frame = frame
			anim_screen.animation = anim_name
			anim_screen.frame = frame

func set_color_screen() -> void:
	if not is_instance_valid(anim_screen):
		return
	energy_percentage = (energy / energy_limit) * 100 
	if energy_percentage > 70 and energy_percentage <= 100:
		anim_screen.modulate = Color(0.545, 0.675, 0.059)
	elif energy_percentage > 30 and energy_percentage < 69:
		anim_screen.modulate = Color(1.0, 0.843, 0.0)
	elif energy_percentage > 0 and energy_percentage < 29:
		anim_screen.modulate = Color(0.827, 0.184, 0.184)

func restart_move_timer() -> void:
	is_moving_recently = true
	timer.start()

func _on_timer_timeout() -> void:
	is_moving_recently = false

func _on_drop_timeout() -> void:
	has_crashed = false
	input_left = true
	input_right = true
	input_jump = true
