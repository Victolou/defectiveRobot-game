class_name ConveyorBelt
extends Node2D

@onready var t_1: Sprite2D = %T1
@onready var t_2: Sprite2D = %T2
@onready var b_1: Sprite2D = %B1
@onready var b_2: Sprite2D = %B2
@onready var can_move_duration: Timer = $CanMoveDuration

enum direction { left = -1, right = 1 }
var sprite_width;
var can_move: bool = false
var moving_stop: bool = true
var top_direction: int = -1
var bottom_direction: int = 1

func _ready() -> void:
	sprite_width = t_1.texture.get_width()

func _process(delta: float) -> void:
	if moving_stop:
		return
	
	for sprite in [t_1, t_2, b_1, b_2]:
		if sprite.name.begins_with("T"):
			if can_move:
				GLOBAL.velocity = lerp(GLOBAL.velocity, GLOBAL.speed, 0.1) 
				sprite.position.x += top_direction * GLOBAL.speed * delta
				#TOP SLOOP
				if sprite.position.x <= -sprite_width:
					sprite.position.x += 2 * sprite_width
				elif sprite.position.x >= sprite_width:
					sprite.position.x -= 2 * sprite_width
		else:
			sprite.position.x += bottom_direction * GLOBAL.speed * delta
			#BOTTOM SLOOP
			if sprite.position.x <= -sprite_width:
				sprite.position.x += 2 * sprite_width
			elif sprite.position.x >= sprite_width:
				sprite.position.x -= 2 * sprite_width
			
func set_running() -> void:
	moving_stop = !moving_stop
				
func is_stopping(value: bool) -> void:
	moving_stop = value
	
func set_can_move(value: bool) -> void:
	can_move = value
	
func change_top_direction(value: String) -> void:
	top_direction = direction.get(value, "right")
	
func change_bottom_direction(value: String) -> void:
	bottom_direction = -direction.get(value, "right")
	
func _on_can_move_duration_timeout() -> void:
	can_move = false
	change_bottom_direction("left")
