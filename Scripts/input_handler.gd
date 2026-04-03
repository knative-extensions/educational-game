extends Node

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("ui_start"):
		if ConveyerController.destination.size() > 0:
			ConveyerController.can_send = true
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()