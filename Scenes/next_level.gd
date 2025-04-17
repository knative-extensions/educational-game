extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	print("NEXT LEVEL Button Pressed")
	var current_scene = get_tree().current_scene
	var current_file_path = current_scene.scene_file_path
	var next_level_ind = current_file_path.to_int() + 1
	var next_file_path = "res://Scenes/level_" + str(next_level_ind) + ".tscn"
	if !ResourceLoader.exists(next_file_path): 
		next_file_path =  "res://Scenes/Ending.tscn"
	get_tree().change_scene_to_file(next_file_path)
	ConveyerController.initialize()
	
	
