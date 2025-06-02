class_name Main extends Node2D

@onready var player: Player = $player
@onready var crusher: Crusher = $crusher
@onready var menu_home: MenuHome = $menuHome
@onready var background: Background = $background

func _ready() -> void:
	pass

func _on_menu_home_on_start_game() -> void:
	player.set_running()
	menu_home.hide()

func _on_player_on_player_is_on_floor() -> void:
	crusher.set_running()
	background.set_running()

func _on_player_on_back_crusher() -> void:
	crusher.apply_pushback(player.power_advantage)

func _on_crusher_on_player_reached(body: Node) -> void:
	if body == player:
		print("¡Player alcanzado!")
		player.set_running()
		background.change_direction()

func _on_crusher_on_player_crusher(body: Node) -> void:
	if body == player:
		background.stop_layer0()
		background.stop_layer1()
		crusher.kill_player()

func _on_player_on_player_no_energy() -> void:
	crusher.set_external_pushback(0.0)
