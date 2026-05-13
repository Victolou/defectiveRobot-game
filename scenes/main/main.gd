class_name Main extends Node2D

@onready var player: Player = $player
@onready var crusher: Crusher = $crusher
@onready var home: Home = $home
@onready var background: Background = $background
@onready var conveyor_belt: ConveyorBelt = $conveyorBelt
@onready var stats: Stats = $stats
@onready var spawner: Spawner = $spawner
@onready var game_over: gameOver = $game_over

var game_speed: = 0
var total_time: String

func _ready() -> void:
	stats.hide()
	stats.set_bar_max_limit(player.energy)
	
func _process(_delta: float) -> void:
	if not player.death_played:
		background.set_extra_speed_layer0(200 + game_speed)
		background.set_extra_speed_layer1(200 + game_speed)

func _on_home_on_start_game() -> void:
	home.hide()
	stats.show()
	player.set_running()

func _on_player_on_landed_player() -> void:
	stats.set_running_conometer(true)
	crusher.set_running()
	background.set_running()
	conveyor_belt.set_running()
	
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
	stats.update_counts("timer", 1)
	player.has_crashed = true
	
func _on_spawner_on_battery_crash() -> void:
	player.energyChange += 1
	stats.update_counts("energyMeter", 1)
	
func _on_player_on_player_energy_used() -> void:
	stats.update_energy_bar(player.energy_recovered, true)
	stats.update_counts("energyMeter", 1, false)
	stats.update_counts("timer", 1, false)
	
func _on_player_on_player_no_energy() -> void:
	total_time = stats.final_meter()
	crusher.set_external_pushback(0.0)
	background.change_layer0_direction("right")
	background.change_layer1_direction("right")
	conveyor_belt.change_bottom_direction("left")
	
func _on_crusher_on_player_end() -> void:
	stats.set_running_conometer(false)
	game_over.disappear()
	player.is_crushed()
	crusher.kill_player()
	stats.hide()
	spawner.it_is_game_over()
	
func _on_player_on_player_jumps_on_the_stage() -> void:
	background.playings_layers(false)
	
	conveyor_belt.set_can_move(true)
	conveyor_belt.change_top_direction("left")
	conveyor_belt.change_bottom_direction("left")

func _on_player_on_player_moves_forward_on_the_stage() -> void:
	background.playings_layers(true)
	background.change_layer0_direction("left")
	background.change_layer1_direction("left")
	
	conveyor_belt.can_move_duration.start()
	conveyor_belt.set_can_move(true)
	if player.input_jump:
		conveyor_belt.change_bottom_direction("right")

func _on_player_on_player_has_stopped_on_the_stage() -> void:
	background.playings_layers(true)
	background.change_layer0_direction("right")
	background.change_layer1_direction("right")
		
	conveyor_belt.set_can_move(false)
	conveyor_belt.change_bottom_direction("left")

func _on_timer_timeout() -> void:
	game_speed += 50
