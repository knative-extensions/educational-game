extends Control

func _ready():
	var start_button = $MainLayout/VBox/Footer/StartButton
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	# Load Level 1
	get_tree().change_scene_to_file("res://Scenes/basicEventFlow.tscn")
