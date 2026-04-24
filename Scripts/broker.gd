extends Node2D

func _ready():
	ConveyerController.brokerpos = self.global_position

func _process(delta):
	pass

func duplicate_events() -> void:
	var dest_size = ConveyerController.destination.size()

	if dest_size <= 1:
		ConveyerController.can_send = true
		return

	var original_events = ConveyerController.events.duplicate()
	var new_events = []

	for i in range(original_events.size()):
		var original_box = original_events[i]
		if not is_instance_valid(original_box):
			continue

		new_events.append(original_box)

		for j in range(dest_size - 1):
			var clone = original_box.duplicate()
			get_tree().current_scene.add_child(clone)
			clone.global_position = original_box.global_position
			new_events.append(clone)

	ConveyerController.events = new_events
	print("Events after duplication: ", ConveyerController.events.size())
	ConveyerController.can_send = true


func _on_broker_click_area_entered(area):
	if area.is_in_group("Box") and area.get_parent().returning:
		var box = area.get_parent()

		if not is_instance_valid(box):
			return

		var dest_size = ConveyerController.destination.size()
		var spawn_pos = box.global_position

		
		var clones = []
		for j in range(dest_size):
			var clone = box.duplicate()
			clone.returning = false
			clone.sending = false
			get_tree().current_scene.add_child(clone)
			clone.global_position = spawn_pos
			clones.append(clone)

		
		box.queue_free()
		ConveyerController.events.clear()
		ConveyerController.events = clones

		print("Enriched events ready: ", ConveyerController.events.size())

		ConveyerController.started = false


func _on_broker_click_mouse_entered():
	$hoverlabel.visible = true

func _on_broker_click_mouse_exited():
	$hoverlabel.visible = false
