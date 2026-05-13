extends Control

@export var PLAYER_NODE: NodePath
@onready var player: Player = get_node(PLAYER_NODE)

@onready var spinner: TextureRect = %Spinner
@onready var electricity: TextureRect = %Electricity

func _process(_delta: float) -> void:
	show_state()
	
func show_state() -> void:
	if player.has_crashed and player.death_played == false:
		spinner.modulate.a = 1.0
		spinner.get_node("AnimatedSprite2D").play("default")
	else:
		spinner.modulate.a = 0.0
		spinner.get_node("AnimatedSprite2D").stop()
		
	if player.recovering:
		electricity.modulate.a = 1.0
		electricity.get_node("AnimatedSprite2D").play("default")
	else:
		electricity.modulate.a = 0.0
		electricity.get_node("AnimatedSprite2D").stop()
