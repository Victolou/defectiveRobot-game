class_name gameOver extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var battery: Battery = %battery

var face_battery

func _ready() -> void:
	color_rect.modulate.a = 0
	battery.modulate.a = 0
	battery.position.x = 640
	battery.set_move_speed(0)
	battery.get_node("Area2D").get_child(0).disabled = true
	face_battery = battery.get_node("face")
	face_battery.position.x = 0

func disappear():
	color_rect.visible = true
	battery.visible = true
	
	# Estado inicial
	color_rect.modulate.a = 1
	battery.modulate.a = 0
	
	var tween = create_tween()
	
	tween.tween_property(color_rect, "modulate:a", 0, 3.0)

	tween.parallel().tween_property(battery, "modulate:a", 1, 1.5).set_delay(1.5)
	tween.parallel().tween_property(battery, "position:y", 220.0, 1.5).set_delay(1.5).set_ease(tween.EASE_IN_OUT)
	tween.tween_interval(1.5)
	tween.tween_property(face_battery, "position:x", -4.0, 0.2)
	tween.tween_interval(0.2)
	tween.tween_property(face_battery, "position:x", 4.0, 0.2)
	tween.tween_interval(0.2)
	tween.tween_property(face_battery, "position:x", -4.0, 0.2)
	tween.tween_interval(0.2)
	tween.tween_property(face_battery, "position:x", 4.0, 0.2)
	tween.tween_interval(0.2)
	tween.tween_property(battery, "position:x", 1300, 1).set_ease(tween.EASE_IN_OUT)

func results_face(value: int) -> void:
	battery.change_face(value)
