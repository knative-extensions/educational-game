extends Area2D


func _input_event(viewport, event, shape_idx):
	if event.is_pressed():
		self.on_click()
		
func on_click():
	print("hi")
	ConveyerController.selected = get_parent()
