class_name Stats extends CanvasLayer

@onready var grid_container_a: GridContainer = %GridContainerA
@onready var grid_container_b: GridContainer = %GridContainerB

var stopwatch_time: float = 0.0
var stopwatch_running: bool = false

var speedometer_count: int = 0
var can_moving_needle = false
var moving_needle = false
var list_minutes = {
	0: "00",
	1: "01",
	2: "02",
	3: "03",
	4: "04",
	5: "05"
}

var final_animation = true

func _ready() -> void:
	grid_container_b.get_node("speedometer").visible = false
	
func _process(delta):
	if stopwatch_running:
		stopwatch_time += delta
		update_conometer()
	if speedometer_count <= 5:
		update_speedometer()

func update_energy_bar(value: float, positive: bool = false) -> void:
	grid_container_a.get_node("energyBar").value += value if positive else -value
	
func set_bar_max_limit(max_energy: float) -> void:
	var energy_bar = grid_container_a.get_node("energyBar")
	if energy_bar:
		energy_bar.max_value = max_energy
		energy_bar.value = max_energy
	
func update_counts(icon_name: String, value: int, positive: bool = true) -> void:
	var label = grid_container_a.get_node(icon_name).get_node("count")
	var count = int(label.text)
	count += value if positive else -value
	count = max(0, count)
	label.text = str(count)
	var this_icon = grid_container_a.get_node(icon_name)
	if positive:
		if icon_name == "timer":
			this_icon.modulate = Color(1, 1, 1, 1)
			pulse_animation(this_icon, "modulate:a", 0.0, 0.1, 1.0, 0.1)
		if icon_name == "energyMeter":
			color_animation(this_icon, 0.3, 0.3, 0.0, Color(0.96, 0.89, 0.51, 1.0))
	if not positive:
		color_animation(grid_container_a, 0, 0.2, 1.0, Color(0.96, 0.89, 0.51, 1.0))
		if icon_name == "energyMeter":
			pulse_animation(this_icon, "scale", Vector2(1.2, 1.2), 0.1, Vector2(1.0, 1.0), 0.1)
		
func update_conometer() -> void:
	var total_ms = int(stopwatch_time * 1000)
	
	var minutes = int(total_ms / 60000.0)
	var seconds = int((total_ms % 60000) / 1000.0)
	var centiseconds = int((total_ms % 1000) / 10.0)

	grid_container_b.get_node("conometer").text = "%02d:%02d:%02d" % [minutes, seconds, centiseconds]
	
func update_speedometer() -> void:
	var get_minutes = grid_container_b.get_node("conometer").text.substr(0, 2)
	var speedometer = grid_container_b.get_node("speedometer")
	
	if get_minutes == "01" and speedometer.visible == false:
		speedometer.visible = true
		await get_tree().process_frame
		pulse_animation(grid_container_b, "modulate:a", 0.0, 0.1, 1.0, 0.1)
		speedometer_count = 1
		
	if get_minutes == "02" and can_moving_needle == false:
		can_moving_needle = true
		
	if list_minutes[speedometer_count] == get_minutes:
		speedometer_count +=1
		if can_moving_needle:
			moving_needle = true
		
	if can_moving_needle and moving_needle:
		grid_container_b.get_node("speedometer/needle").rotation += deg_to_rad(40)
		moving_needle = false
		pulse_animation(grid_container_b, "modulate:a", 0.0, 0.1, 1.0, 0.1)
	
func pulse_animation(item: CanvasItem, property: String, final_valA: Variant, durationA: float, final_valB: Variant, durationB: float) -> void:
	for i in range(5):
		var tween = create_tween()
		tween.tween_property(item, property, final_valA, durationA)
		await tween.finished
		tween = create_tween()
		tween.tween_property(item, property, final_valB, durationB)
		await tween.finished
		
func color_animation(item: CanvasItem, seconsA: float, seconsB: float, seconsInterval: float, color: Color) -> void:
	var tween = create_tween()
	tween.tween_property(item, "modulate", color, seconsA)
	tween.tween_interval(seconsInterval)
	tween.tween_property(item, "modulate", Color(1, 1, 1, 1), seconsB)
		
func set_running_conometer(value: bool) -> void:
	stopwatch_running = value
	
func final_meter() -> String:
	set_running_conometer(false)
	if final_animation:
		color_animation(grid_container_b.get_node("conometer"), 0, 0.2, 1.0, Color(0.90, 0.45, 0.40, 1.0))
		final_animation = false
	return grid_container_b.get_node("conometer").text
