extends Control

func _on_start_pressed():
	# Reset level progress and start the first level
	Level.levelind = 0
	Level.initialise()
	ConveyerController.initialise()
	# The first level in the list is "basicEventFlow"
	get_tree().change_scene_to_file("res://Scenes/basicEventFlow.tscn")

func _on_tutorials_pressed():
	# Placeholder for tutorials functionality
	print("Tutorials button pressed")

func _on_levels_pressed():
	# Placeholder for level selection functionality
	print("Levels button pressed")

func _on_settings_pressed():
	# Placeholder for settings functionality
	print("Settings button pressed")

func _on_quit_pressed():
	get_tree().quit()
