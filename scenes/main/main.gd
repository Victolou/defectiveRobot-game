class_name Main extends Node2D

@onready var player: Player = $player
@onready var crusher: Crusher = $crusher


func _ready() -> void:
	print(player.power_advantage)

func _on_player_on_back_crusher() -> void:
	crusher.apply_pushback(player.power_advantage)
