extends Node



func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				_restart_level()
			KEY_SPACE:
				_start_game()
			KEY_ESCAPE:
				_quit_game()


func _restart_level() -> void:
	print("[InputHandler] Restart pressed")
	Level.initialise()
	get_tree().reload_current_scene()
	ConveyerController.initialise()


func _start_game() -> void:
	# Only start if not already started
	if not ConveyerController.can_send:
		print("[InputHandler] Start pressed (Space)")
		Level.initialise()
		ConveyerController.can_send = true


func _quit_game() -> void:
	print("[InputHandler] Quit pressed (Esc)")
	
	if Level.levelind > 0:
		
		Level.levelind = 0
		Level.initialise()
		ConveyerController.initialise()
		get_tree().change_scene_to_file("res://Scenes/basicEventFlow.tscn")
	else:
		
		get_tree().quit()
