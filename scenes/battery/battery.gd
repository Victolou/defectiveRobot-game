class_name Battery extends Node2D

signal on_player_crash

@export var move_speed: float = 320.0

const GUY_0_BATTERY = preload("res://assets/sprites/entitles/battery/face0_battery.png")
const GUY_1_BATTERY = preload("res://assets/sprites/entitles/battery/face1_battery.png")
const GUY_2_BATTERY = preload("res://assets/sprites/entitles/battery/face2_battery.png")
const GUY_3_BATTERY = preload("res://assets/sprites/entitles/battery/face3_battery.png")

var touched_By_player = false
var extra_speed: float = 0.0
var game_over: bool = false

const faces = {
	0: GUY_0_BATTERY,
	1: GUY_1_BATTERY,
	2: GUY_2_BATTERY,
	3: GUY_3_BATTERY
}

@onready var body: AnimatedSprite2D = $body

func _process(delta: float) -> void:
	if game_over:
		queue_free()
	
	position.x += move_speed * delta
	if not touched_By_player:
		body.play("moving")
	
func set_move_speed(value: float) -> void:
	move_speed = value

func it_is_gamer_over() -> void:
	game_over = true

func set_extra_speed(value: float):
	extra_speed = value

func _on_area_2d_body_entered(other_body: Node2D) -> void:
	if other_body is Player:
		on_player_crash.emit()
		touched_By_player = true
		move_speed = 0
		get_node("face").queue_free()
		body.play("fading")
		await body.animation_finished
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func change_face(value: int) -> void:
	get_node("face").texture = faces[value]
	
