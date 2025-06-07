class_name Stats extends CanvasLayer

@onready var energy_bar: TextureProgressBar = %energyBar
@onready var velocity_bar: TextureProgressBar = %velocityBar

func update_energy_bar(value: float, positive: bool = false) -> void:
	energy_bar.value += value if positive else -value

func update_velocity_bar(value: float) -> void:
	value = clamp(value, 0, velocity_bar.max_value)
	velocity_bar.value = value
	
func set_bars_max_limits(max_energy: float, max_velocity: float) -> void:
	if velocity_bar: 
		velocity_bar.max_value = max_velocity
	if energy_bar:
		energy_bar.max_value = max_energy
		energy_bar.value = max_energy
