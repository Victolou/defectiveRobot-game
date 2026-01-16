class_name Battery extends Node2D

signal on_player_crash

@export var move_speed: float = 300.0
var extra_speed: float = 0.0

@onready var body: AnimatedSprite2D = $body

func _process(delta: float) -> void:
	position.x -= move_speed * delta
	body.play("moving")
	
func set_move_speed(value: float) -> void:
	move_speed = value

func set_extra_speed(value: float):
	extra_speed = value

func _on_area_2d_body_entered(other_body: Node2D) -> void:
	if other_body is Player:
		on_player_crash.emit()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
