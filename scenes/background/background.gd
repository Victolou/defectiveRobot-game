class_name Background extends ParallaxBackground

@onready var layer0: ParallaxLayer = $layer0
@onready var layer1: ParallaxLayer = $layer1

enum direction { left = -1, right = 1 }

var extra_speed_layer0 := 0.0
var extra_speed_layer1 := 0.0

var is_layer0_running := false
var is_layer1_running := false

var layer0_direction: int = 1
var layer1_direction: int = 1

func _ready():
	layer1.motion_offset.x = 800

func _process(delta):
	if is_layer0_running:
		moving(layer0, delta)

	if is_layer1_running:
		moving(layer1, delta)

func set_running():
	is_layer0_running = true
	is_layer1_running = true

func moving(parallax_layer: ParallaxLayer, delta: float):
	var speed := Vector2.ZERO
	var this_direction;
	
	if parallax_layer == layer0:
		speed = Vector2((GLOBAL.speed + 50), 0) + Vector2(extra_speed_layer0, 0)
		this_direction = layer0_direction
	elif parallax_layer == layer1:
		speed = Vector2((GLOBAL.speed - 100), 0) + Vector2(extra_speed_layer1, 0)
		this_direction = layer1_direction
	
	parallax_layer.motion_offset.x += speed.x * this_direction * delta

func change_layer0_direction(value: String):
	layer0_direction = direction.get(value, "right")

func change_layer1_direction(value: String):
	layer1_direction = direction.get(value, "right")

func playings_layers(value: bool):
	is_layer0_running = value
	is_layer1_running = value

func play_layer0(value: bool):
	is_layer0_running = value

func play_layer1(value: bool):
	is_layer1_running = value

func set_extra_speed_layer0(value: float):
	extra_speed_layer0 = value

func set_extra_speed_layer1(value: float):
	extra_speed_layer1 = value
