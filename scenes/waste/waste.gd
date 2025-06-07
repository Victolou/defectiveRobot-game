class_name Waste extends Node2D

signal on_player_crash

const TRANSFORMED_TEXTURE = preload("res://assets/sprites/entitles/waste2.png")

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var move_speed: float = 300.0

var change_sprite = false
var is_crusher: bool = false

func _process(delta: float) -> void:
	position.x -= move_speed * delta

func set_move_speed(value: float) -> void:
	move_speed = value
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	on_player_crash.emit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "wasteCrush":
		sprite_2d.texture = TRANSFORMED_TEXTURE
