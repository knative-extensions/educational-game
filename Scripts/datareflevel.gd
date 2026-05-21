extends Node2D

var noofboxesadded = 0
var inlevelrefbox = null
var inlevelrefbox2 = null
var event_boxes = []

func _on_storage_area_entered(area):

	if area.is_in_group("largepayload"):

		ConveyerController.dragging = false

		noofboxesadded += 1
		
		var event_box = preload("res://Scenes/event_box.tscn").instantiate()
		event_boxes.append(event_box)

		event_box.global_position = $opendatarefletterpoint.global_position

		if noofboxesadded == 1:

			

			if area.payloadtype == "Blue":

				$BlueBox.texture = preload("res://2D Assets/boxes/blueBox.png")
				$BlueBox.visible = true
				event_box.boxType = "Blue"
				event_box.texture = preload("res://2D Assets/dataref/blue_1a.png")
				event_box.scale = Vector2(0.2,0.2)

			else:

				$BlueBox.texture = preload("res://2D Assets/boxes/redBox.png")
				$BlueBox.visible = true

				event_box.texture = preload("res://2D Assets/dataref/red_1A.png")
				event_box.scale = Vector2(0.2,0.2)
				
				
			get_tree().current_scene.call_deferred("add_child", event_box)
				
			area.hide()
		if noofboxesadded == 2:
			if area.payloadtype == "Blue":

				$RedBox.texture = preload("res://2D Assets/boxes/blueBox.png")
				$RedBox.visible = true
				event_box.boxType = "Blue"
				event_box.texture = preload("res://2D Assets/dataref/blue_1b.png")
				event_box.scale = Vector2(0.2,0.2)

			else:

				$RedBox.texture = preload("res://2D Assets/boxes/redBox.png")
				$RedBox.visible = true

				event_box.texture = preload("res://2D Assets/dataref/red_1B.png")
				event_box.scale = Vector2(0.2,0.2)
			

			get_tree().current_scene.call_deferred("add_child", event_box)
		
		
			area.hide()
	


func _on_button_pressed():

	if event_boxes.size() > 0:

		for box in event_boxes:

			if is_instance_valid(box):
				if box.boxType == "Red":
					box.texture = preload("res://2D Assets/dataref/red_closed.png")


				else:
					box.texture = preload("res://2D Assets/dataref/blue_closed.png")

	else:
		print("we dont got any!!")
