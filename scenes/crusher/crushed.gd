class_name Crusher extends Node2D

signal on_player_reached
signal on_player_crusher

@onready var image_crusher: Sprite2D = %imageCrusher

@export var move_speed_x: float = 300.0
@export var move_speed_y: float = 3500.0
@export var upper_limit: float = 0.0
@export var lower_limit: float = 205.0
@export var left_limit: float = 0.0

var crusher_running: bool = false
var moving_down: bool = false

var external_pushback := 0.0
var pushback_decay := 10

func _ready() -> void:
	left_limit = -image_crusher.texture.get_width()
	
func _process(delta: float) -> void:
	
	if crusher_running == false:
		return
	
	position.x += (move_speed_x * delta) - external_pushback
	external_pushback = max(external_pushback - pushback_decay * delta, 0)
	
	if position.x < left_limit:
		position.x = left_limit

	if moving_down:
		position.y += move_speed_y * delta
		if position.y >= lower_limit:
			position.y = lower_limit
	else:
		position.y -= move_speed_y * delta
		if position.y <= upper_limit:
			position.y = upper_limit
	
func set_running() -> void:
	crusher_running = !crusher_running
	
func set_external_pushback(value: float) -> void:
	external_pushback = value

func apply_pushback(amount: float) -> void:
	external_pushback += amount

func kill_player() -> void:
	move_speed_x = 0
	moving_down = true
	position.y = lower_limit

func _on_player_reached_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("on_player_reached", body) 

func _on_player_crusher_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("on_player_crusher", body) 
