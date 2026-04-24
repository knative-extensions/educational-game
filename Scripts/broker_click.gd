extends Area2D
# Called when the node enters the scene tree for the first time.
var isConnected = false

func _input_event(viewport, event, shape_idx):
	if isConnected == false:
		if event.is_pressed() and ConveyerController.selected != null:
			self.on_click()
			isConnected = true

func on_click():
	print("hey")
	AudioManager.play_click_end() 
	ConveyerController.destination.append(get_parent().get_position())
	transfer_box()


func transfer_box():
	print("sending")
	ConveyerController.create_conveyor()

# Replace with function body.
