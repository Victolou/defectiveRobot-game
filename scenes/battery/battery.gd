class_name Battery extends Node2D

signal on_player_crash

@export var move_speed: float = 300.0

func _process(delta: float) -> void:
	position.x -= move_speed * delta

func set_move_speed(value: float) -> void:
	move_speed = value

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		on_player_crash.emit()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
