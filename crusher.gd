class_name Crusher extends RigidBody2D

@export var move_speed: float = 300.0

func _process(delta: float) -> void:
	position.x -= move_speed * delta
