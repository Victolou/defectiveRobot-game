class_name Main extends Node2D

@onready var player: Player = $player
@onready var crusher: Crusher = $crusher
@onready var home: Home = $home
@onready var background: Background = $background
@onready var stats: Stats = $stats
@onready var spawner: Spawner = $spawner

func _ready() -> void:
	stats.hide()
	stats.set_bars_max_limits(player.energy, player.limit_power_advantage)
	
func _process(_delta: float) -> void:
	stats.update_velocity_bar(player.power_advantage)

func _on_home_on_start_game() -> void:
	home.hide()
	stats.show()
	player.set_running()
	
func _on_player_on_player_is_on_floor() -> void:
	crusher.set_running()
	background.set_running()

func _on_player_on_back_crusher() -> void:
	stats.update_energy_bar(player.energy_loss)
	crusher.apply_pushback(player.power_advantage)

func _on_crusher_on_player_reached() -> void:
	crusher.up_crusher()
	spawner.stop()
	player.set_reached()
	player.set_power_advantage(0)
	background.change_direction()
	
func _on_crusher_on_player_crusher() -> void:
	background.stop_layer0()
	background.stop_layer1()
	crusher.kill_player()
	
func _on_crusher_on_waste_reached() -> void:
	crusher.up_crusher()
	
func _on_crusher_on_waste_crusher() -> void:
	crusher.lower_crusher()

func _on_spawner_on_waste_crash() -> void:
	player.set_power_advantage(0)
	
func _on_spawner_on_battery_crash() -> void:
	stats.update_energy_bar(20, true)
	player.recover_energy(20)
	
func _on_player_on_player_no_energy() -> void:
	crusher.set_external_pushback(0.0)
	
func _on_timer_timeout() -> void:
	pass # Replace with function body.
