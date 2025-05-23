extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	print("restart clicked")
	#if not Level.nextLevel:
		#Level.levelind-=1
	Level.initialise()
	get_tree().reload_current_scene()
	ConveyerController.initialise()
