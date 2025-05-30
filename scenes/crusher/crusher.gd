class_name Crusher extends Area2D

@export var move_speed: float = 500.0
@export var upper_limit: float = 0.0
@export var lower_limit: float = 205.0

var moving_down := true
var external_pushback := 0.0
var pushback_decay := 20.0

func _process(delta: float) -> void:
	position.x += (move_speed * delta) - external_pushback
	external_pushback = max(external_pushback - pushback_decay * delta, 0)

	if moving_down:
		position.y += move_speed * delta
		if position.y >= lower_limit:
			position.y = lower_limit
			moving_down = false
	else:
		position.y -= move_speed * delta
		if position.y <= upper_limit:
			position.y = upper_limit
			moving_down = true
			
func apply_pushback(amount: float) -> void:
	external_pushback += amount
