extends StaticBody2D

@export var PLAYER_NODE: NodePath
@export var BACKGROUND_NODE: NodePath

@onready var player = get_node(PLAYER_NODE)
@onready var background = get_node(BACKGROUND_NODE)

@onready var upper_conveyor_belt: AnimatedSprite2D = $upper_conveyor_belt
@onready var lower_conveyor_belt: AnimatedSprite2D = $lower_conveyor_belt

var has_player_landed := false
var upper_conveyor_last_frame := 0

var has_saved_speed := false
var speed_background_previus: = 1.0
var is_jumping := false

var frames := 24
var sprite_repeat_length := 6.9
var animation_fps := 24.0

func _process(_delta) -> void:
	# Detectar primer aterrizaje del jugador
	if not has_player_landed and player.is_on_floor():
		has_player_landed = true

	if not has_player_landed:
		# No iniciar animaciones todavía
		return
		
	if player.death_played:
		upper_conveyor_belt.speed_scale = 0
		lower_conveyor_belt.speed_scale = 0
		return

	if player.input_jump and player.death_played == false:
		background.play_layer0()
		background.play_layer1()
		is_jumping = true
	else:
		background.stop_layer0()
		background.stop_layer1()
		is_jumping = false
		
	calculate_animation(lower_conveyor_belt, "moving")

	if player.is_moving_recently or not player.is_on_floor():
		background.change_direction_left()
		calculate_animation(upper_conveyor_belt, "moving")
	else:
		background.change_direction_right()
		# Pausar animación congelando en el frame actual
		upper_conveyor_last_frame = upper_conveyor_belt.frame
		upper_conveyor_belt.speed_scale = 0

func calculate_animation(animation: AnimatedSprite2D, anim_name: String) -> void:
	var speed: float

	if is_jumping:
		# Guardar velocidad solo la primera vez que empieza el salto
		if not has_saved_speed:
			speed_background_previus = background.speed_layer1.x
			has_saved_speed = true
		speed = speed_background_previus
	else:
		# Cuando ya no está saltando, volver a leer directamente del fondo
		has_saved_speed = false
		speed = background.speed_layer1.x

	if speed == 0:
		speed = 1.0  # Evita división por cero

	var fps_base: float = frames * speed / sprite_repeat_length

	if animation.animation != anim_name:
		animation.animation = anim_name

	if animation_fps != 0:
		animation.speed_scale = fps_base / animation_fps

	if not animation.is_playing():
		animation.play()
