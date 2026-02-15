class_name Waste extends Node2D

signal on_player_crash

@onready var animated_waste: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_duration: Timer = $AnimationDuration
@onready var colision_a: CollisionPolygon2D = $Area2D/ColisionA
@onready var colision_b: CollisionPolygon2D = $Area2D/ColisionB
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var move_speed: float = 300.0
@export var acceleration: float = 12.0

var colors = {
	0: "blue",
	1: "green",
	2: "magenta",
	3: "red",
	4: "teal"
}
var define_color: bool = true
var color_number: int = 0

var extra_speed: float = 0.0
var can_move: bool = false
var current_speed: float = 0.0

var change_sprite = false
var is_crusher: bool = false
var run_animation: bool = false
var value_animation: int = 0

func _process(delta: float) -> void:
	set_color()
	
	var target_speed := 0.0

	if can_move:
		target_speed = move_speed + extra_speed

	current_speed = lerp(current_speed, target_speed, acceleration * delta)

	position.x -= current_speed * delta
	
	set_animation(value_animation)

func set_color() -> void:
	if define_color:
		var random_number = randi() % 5
		color_number = random_number
		define_color = false 
	
func set_animation(value: int) -> void:	
	var value_str = str(value)
	
	if not is_crusher:
		animated_waste.animation = value_str + "_" + colors[color_number]
	else:
		if value in [0, 1]: 
			animated_waste.animation = "4_" + colors[color_number]
		else: 
			animated_waste.animation = "5_" + colors[color_number]
		
	if value in [0, 1]:
		colision_a.disabled = true
		colision_b.disabled = false
	else:
		colision_a.disabled = false
		colision_b.disabled = true
	
	if value in [0, 3]:
		animated_waste.get_parent().scale.x = -1
		visible_on_screen_notifier_2d.position = Vector2(-98.00, 2.00)
	else:
		animated_waste.get_parent().scale.x = 1
		visible_on_screen_notifier_2d.position = Vector2(98.00, 2.00)
		
	if run_animation:
		if not is_crusher:
			animated_waste.play(value_str +"_"+ colors[color_number])
	else:
		animated_waste.frame = 0
	
func set_move_speed(value: float) -> void:
	move_speed = value
	
func set_extra_speed(value: float):
	extra_speed = value
	
func set_can_move(value: bool) -> void:
	can_move = value
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_animation_duration_timeout() -> void:
	run_animation = false
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "crushing":
		is_crusher = true	

func _on_area_2d_body_entered(_body: Node2D) -> void:
	animation_duration.start()
	run_animation = true
	on_player_crash.emit()
