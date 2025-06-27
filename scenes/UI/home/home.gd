class_name Home extends Control

signal on_start_game

func _input(event):
	if event.is_action_pressed("ready"):
		on_start_game.emit()
		
func _on_button_pressed() -> void:
	on_start_game.emit()
