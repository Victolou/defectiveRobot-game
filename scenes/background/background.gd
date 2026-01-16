class_name Background extends ParallaxBackground

@onready var layer0: ParallaxLayer = $layer0
@onready var layer1: ParallaxLayer = $layer1

@export var speed_layer0 := Vector2(300, 0)
@export var speed_layer1 := Vector2(150, 0)

var extra_speed_layer0 := 0.0
var extra_speed_layer1 := 0.0

var is_layer0_running := false
var is_layer1_running := false

var direction := false

func _process(delta):
	if is_layer0_running:
		moving(layer0, delta, direction)

	if is_layer1_running:
		moving(layer1, delta, direction)

func set_running():
	is_layer0_running = true
	is_layer1_running = true

func moving(parallax_layer: ParallaxLayer, delta: float, direction_right: bool):
	var speed := Vector2.ZERO
	
	if parallax_layer == layer0:
		speed = speed_layer0 + Vector2(extra_speed_layer0, 0)
	elif parallax_layer == layer1:
		speed = speed_layer1 + Vector2(extra_speed_layer1, 0)
	
	var dir := 1 if direction_right else -1
	parallax_layer.motion_offset.x += speed.x * dir * delta

func change_direction_right():
	direction = true

func change_direction_left():
	direction = false

func play_layer0():
	is_layer0_running = true
	
func play_layer1():
	is_layer1_running = true

func stop_layer0():
	is_layer0_running = false

func stop_layer1():
	is_layer1_running = false

func set_extra_speed_layer0(value: float):
	extra_speed_layer0 = value

func set_extra_speed_layer1(value: float):
	extra_speed_layer1 = value
