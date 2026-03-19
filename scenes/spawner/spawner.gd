class_name Spawner extends Node

signal on_waste_crash
signal on_battery_crash

const WASTE_SCENE = preload("res://scenes/waste/waste.tscn")
const BATTERY_SCENE = preload("res://scenes/battery/battery.tscn")

@export var PLAYER_NODE: NodePath

@onready var player: Player = get_node(PLAYER_NODE)

var viewport: Viewport

func _ready() -> void:
	viewport = get_viewport()
	player.on_player_start_advancing.connect(_on_player_start_advancing)
	player.on_player_stop_advancing.connect(_on_player_stop_advancing)
	player.on_player_limit_advancing.connect(_on_player_limit_advancing)

#GENERAL
func it_is_game_over() -> void:
	var target_types = [Waste, Battery]
	
	for child in get_children():
		for t in target_types:
			if is_instance_of(child, t):
				child.it_is_gamer_over()
				break
				
#WASTE
func spawn_waste() -> void:
	var waste_instance: Waste = WASTE_SCENE.instantiate()
	waste_instance.z_index = 0
	var random_number = randi() % 4  
	
	waste_instance.on_player_crash.connect(on_waste_hit_player)
	waste_instance.on_waste_deleted.connect(_on_waste_delete)
	
	waste_instance.position.x = viewport.get_visible_rect().end.x + 150
	waste_instance.position.y = 383.0
	waste_instance.value_animation = random_number

	add_child(waste_instance)

func on_waste_hit_player() -> void:
	on_waste_crash.emit()
	
func _on_player_limit_advancing() -> void:
	spawn_waste()
	
func _on_waste_delete() -> void:
	spawn_battery()

#BATTERY
func spawn_battery() -> void:
	var battery_instance: Battery = BATTERY_SCENE.instantiate()
	var random_number = randi_range(0, 3)
	
	battery_instance.z_index = 2
	battery_instance.on_player_crash.connect(on_battery_hit_player)
	
	battery_instance.position.x = viewport.get_visible_rect().end.x + -1400
	battery_instance.position.y = 220.0
	
	battery_instance.change_face(random_number)
	
	add_child(battery_instance)

func on_battery_hit_player() -> void:
	on_battery_crash.emit()
	
#PLAYER EVENTS
func _on_player_start_advancing() -> void:
	for child in get_children():
		if child is Waste:
			child.set_can_move(true)
			child.can_move_duration.start()

func _on_player_stop_advancing() -> void:
	for child in get_children():
		if child is Waste:
			child.set_can_move(false)
