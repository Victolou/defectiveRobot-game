class_name Main extends Node2D

@onready var player: Player = $player
@onready var crusher: Crusher = $crusher
@onready var home: Home = $home
@onready var background: Background = $background
@onready var stats: Stats = $stats
@onready var spawner: Spawner = $spawner

var game_speed: = 0

func _ready() -> void:
	stats.hide()
	stats.set_bars_max_limits(player.energy, player.limit_power_advantage)
	
func _process(_delta: float) -> void:
	if not player.death_played:
		spawner.set_extra_speed_to_waste(200 + game_speed)
		background.set_extra_speed_layer0(200 + game_speed)
		background.set_extra_speed_layer1(200 + game_speed)

func _on_home_on_start_game() -> void:
	home.hide()
	stats.show()
	player.set_running()
	
func _on_player_on_player_is_on_floor() -> void:
	crusher.set_running()
	background.set_running()

func _on_player_on_back_crusher() -> void:
	stats.update_energy_bar(player.energy_loss)
	crusher.apply_pushback(1)

func _on_crusher_on_player_reached() -> void:
	crusher.up_crusher()

func _on_crusher_on_waste_reached() -> void:
	crusher.up_crusher()
	
func _on_crusher_on_waste_lowering() -> void:
	crusher.lower_crusher()

func _on_spawner_on_waste_crash() -> void:
	pass
	
func _on_spawner_on_battery_crash() -> void:
	stats.update_energy_bar(20, true)
	player.recover_energy(20)
	
func _on_player_on_player_no_energy() -> void:
	crusher.set_external_pushback(0.0)
	background.change_direction_right()
	
func _on_crusher_on_player_end() -> void:
	player.death_played = true
	player.position.y = 395.0
	player.anim_robot.play("death2")
	
	if player.has_node("screen"):
		var screen_node = player.get_node("screen")
		screen_node.queue_free()
	
	crusher.kill_player()
	player.set_trapped()
	spawner.stop()
	background.stop_layer0()
	background.stop_layer1()
	
func _on_timer_timeout() -> void:
	game_speed += 50

#borrable?
func _on_player_on_player_jump() -> void:
	pass
