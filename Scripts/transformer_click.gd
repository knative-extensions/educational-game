extends Area2D

var isConnected = false

func _input_event(viewport, event, shape_idx):
	if isConnected == false:
		if event.is_pressed() and ConveyerController.selected != null:
			self.on_click()
			isConnected = true

func on_click():
	print("transformer clicked")
	AudioManager.play_click_end()
	ConveyerController.destination.append(get_parent().get_position())
	ConveyerController.create_conveyor()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Box") and not area.get_parent().returning:
		var box = area.get_parent()

		Level.transformerUsed = true


		box.boxType = "Blue"
		box.set_texture(preload("res://2D Assets/boxes/blueBoxPinkRectangle.png"))
		print("Transformed box to: ", box.boxType)

		box.returning = true


		var tween = get_tree().create_tween()
		tween.tween_property(box, "global_position", ConveyerController.brokerpos, 2.0).set_trans(Tween.TRANS_LINEAR)
