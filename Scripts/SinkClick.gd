extends Area2D
# Called when the node enters the scene tree for the first time.
func _input_event(viewport, event, shape_idx):
	if event.is_pressed() and ConveyerController.selected != null:
		self.on_click()

func on_click():
	print("hey")
	ConveyerController.destination.append(get_parent().get_position())
	transfer_box()

func transfer_box():
	print("sending")
	ConveyerController.create_conveyor()
	#draw_line(ConveyerController.selected.get_global_position(), get_global_position(), Color.GREEN)

func _on_body_entered(node: Node2D) -> void:
	print("body entered")

func _on_area_entered(area: Area2D) -> void:
	print("area entered")
	if area.is_in_group("Box"):
		Level.sinkUsed=true
		print(get_parent().expectedType)
		if area.get_parent().boxType != get_parent().expectedType:
			print("Not Expected Box")
			Level.sinkBoxMatchPresent=false
