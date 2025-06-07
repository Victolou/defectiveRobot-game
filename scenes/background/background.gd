class_name Background extends ParallaxBackground

@onready var layer0: ParallaxLayer = $layer0
@onready var layer1: ParallaxLayer = $layer1

@export var speed_layer0 := Vector2(300, 0)
@export var speed_layer1 := Vector2(150, 0)

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

func moving(parallax_layer: ParallaxLayer, delta, path: bool = false):
	if path:
		parallax_layer.motion_offset.x += speed_layer0.x * delta
	else:
		parallax_layer.motion_offset.x -= speed_layer0.x * delta

func change_direction():
	direction = !direction
	
func stop_layer0():
	is_layer0_running = false

func stop_layer1():
	is_layer1_running = false
