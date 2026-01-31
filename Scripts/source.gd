extends Sprite2D

@export var boxType: String
@export var sending = false
var destination

func _ready() -> void:
	pass


func _input_event(viewport, event, shape_idx) -> void:
	print(event)
	if event.is_pressed():
		self.on_click()
		
func on_click():
	print("yup")
	if !ConveyerController.source_is_ready:
		ConveyerController.source_is_ready = true
		print("ram ram")
		



func _on_area_2d_mouse_entered():
	$Panel.show() # Replace with function body.


func _on_area_2d_mouse_exited():
	$Panel.hide() # Replace with function body.



	 # Replace with function body.


func _on_timer_timeout():
	if ConveyerController.can_send == true:
		print("hello")
		var event_scene = preload("res://Scenes/random_event.tscn")
		var event = event_scene.instantiate()
		event.position = self.position
		self.get_parent().add_child(event)
		ConveyerController.random_events.append(event)
		print(ConveyerController.random_events)
		if ConveyerController.alt_sinks.size() > 0:
			var random_index = randi() % ConveyerController.alt_sinks.size()
			destination = ConveyerController.alt_sinks[random_index].position
			print(ConveyerController.destination)
			
	
		else:
			print("No alternate sinks available!")
		
		for i in ConveyerController.random_events.size():
			if is_instance_valid(ConveyerController.random_events[i]): 
				if event.position == ConveyerController.random_events[i].position:
					ConveyerController.random_events[i].sending = true
					var tween = get_tree().create_tween()
					tween.tween_property(ConveyerController.random_events[i], "position", destination, 2).set_trans(Tween.TRANS_LINEAR)
					await tween.finished
