class_name Spawner extends Node

signal on_waste_crash
signal on_battery_crash

const WASTE_SCENE = preload("res://scenes/waste/waste.tscn")
const BATTERY_SCENE = preload("res://scenes/battery/battery.tscn")

const GUY_0_BATTERY = preload("res://assets/sprites/entitles/guy0_battery.png")
const GUY_1_BATTERY = preload("res://assets/sprites/entitles/guy1_battery.png")
const GUY_2_BATTERY = preload("res://assets/sprites/entitles/guy2_battery.png")
const GUY_3_BATTERY = preload("res://assets/sprites/entitles/guy3_battery.png")

@export var PLAYER_NODE: NodePath

@onready var player = get_node(PLAYER_NODE)
@onready var timer_waste: Timer = %timer_waste
@onready var timer_battery: Timer = %timer_battery
@onready var cooldown_battery_timer: Timer = %cooldown_battery_timer

var viewport: Viewport

func _ready() -> void:
	viewport = get_viewport()

#GENERAL
func respawn_probability(value: float, value_limit: float) -> float:
	return clamp(1.0 - (value / value_limit), 0.0, 1.0)
	
func stop() -> void:
	timer_waste.stop()
	timer_battery.stop()

	var target_types = [Waste, Battery]

	for child in get_children():
		for t in target_types:
			if is_instance_of(child, t):
				child.set_move_speed(0)
				child.set_extra_speed(0)
				break

func set_extra_speed_to_waste(value: float) -> void:
	for child in get_children():
		if is_instance_of(child, Waste):
			child.set_extra_speed(value)

#WASTE
func spawn_waste() -> void:
	var waste_instance: Waste = WASTE_SCENE.instantiate()
	waste_instance.on_player_crash.connect(on_waste_hit_player)
	
	waste_instance.position.x = viewport.get_visible_rect().end.x + 150
	waste_instance.position.y = 422.0

	add_child(waste_instance)

func on_waste_hit_player() -> void:
	on_waste_crash.emit()

func _on_timer_waste_timeout() -> void:
	spawn_waste()
	
#BATTERY
func spawn_battery() -> void:
	var battery_instance: Battery = BATTERY_SCENE.instantiate()
	battery_instance.on_player_crash.connect(on_battery_hit_player)
	
	battery_instance.position.x = viewport.get_visible_rect().end.x + 150
	battery_instance.position.y = 300
	
	var num = randi_range(0, 3)
	
	const BATTERY_GUYS = {
		0: GUY_0_BATTERY,
		1: GUY_1_BATTERY,
		2: GUY_2_BATTERY,
		3: GUY_3_BATTERY
	}
	
	battery_instance.get_node("guy").texture = BATTERY_GUYS[num]
	
	add_child(battery_instance)

func on_battery_hit_player() -> void:
	on_battery_crash.emit()
	
func _on_timer_battery_timeout() -> void:
	if not cooldown_battery_timer.is_stopped():
		return
	
	var prob = respawn_probability(player.energy, player.energy_limit)
	if randf() < prob:
		spawn_battery()
		cooldown_battery_timer.start()
