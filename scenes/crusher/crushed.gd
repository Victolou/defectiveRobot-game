class_name Crusher extends Node2D

signal on_player_reached
signal on_waste_reached
signal on_waste_lowering
signal on_player_end

@onready var image_crusher: Sprite2D = %imageCrusher
@onready var reached: Area2D = $reached

@export var move_speed_x: float = 300.0
@export var move_speed_y: float = 800.0
@export var upper_limit: float = 0.0
@export var lower_limit: float = 205.0
@export var left_limit: float = 0.0

var crusher_running: bool = false
var moving_down: bool = false
var moving_stop: bool = false

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
			reached.get_child(0).call_deferred("set_disabled", false)
	else:
		position.y -= move_speed_y * delta
		if position.y <= upper_limit:
			position.y = upper_limit
			
	
	if !moving_stop:
		if position.y == lower_limit:
			moving_down = false

	
func set_running() -> void:
	crusher_running = !crusher_running
	
func set_external_pushback(value: float) -> void:
	external_pushback = value

func apply_pushback(amount: float) -> void:
	external_pushback += amount

func kill_player() -> void:
	moving_stop = true
	move_speed_x = 0
	moving_down = true
	
func up_crusher() -> void:
	moving_down = false
	
func lower_crusher() -> void:
	moving_down = true

func _on_reached_body_entered(_body: Node2D) -> void:
	reached.get_child(0).call_deferred("set_disabled", true)
	on_player_reached.emit()

func _on_lowering_body_entered(body: Node2D) -> void:
	if body.name == "player":
		#lower_crusher()
		position.y = lower_limit
	
func _on_reached_area_entered(_area: Area2D) -> void:
	reached.get_child(0).call_deferred("set_disabled", true)
	on_waste_reached.emit()
	
func _on_lowering_area_entered(_area: Area2D) -> void:
	on_waste_lowering.emit()

func _on_crushing_body_entered(_body: Node2D) -> void:
	on_player_end.emit()
