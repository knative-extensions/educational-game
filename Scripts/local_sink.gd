extends Area2D
func _input_event(viewport, event, shape_idx):
	if event.is_pressed():
		$"../LocalConveyorB".set_point_position(1,self.position)
		get_parent().localsinkattached = true
	
	
