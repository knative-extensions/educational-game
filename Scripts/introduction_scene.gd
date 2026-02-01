extends Control

func _ready():
	var start_button = $MainLayout/VBox/Footer/StartButton
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	# Reset game state to ensure a clean start
	if ConveyerController.has_method("reset_game_state"):
		ConveyerController.reset_game_state()
	
	# Load Level 1
	get_tree().change_scene_to_file("res://Scenes/basicEventFlow.tscn")
