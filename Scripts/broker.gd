extends Node2D

#
#const event_script = preload("res://Scripts/event_box.gd")
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#create_event("")
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#func create_event(color: String) -> void:
	#var event = Sprite2D.new()
	#event.texture = load("res://2D Assets/boxes/redBox.png")
	#var area = Area2D.new()
	#area.shape = RectangleShape2D.new()
	#area.shape.set_size(Vector2(1, 1))
	#event.position = self.position
	#area.set_script(event_script)
	#event.add_child(area)
	#self.add_child(event)

	

func on_click():
	ConveyerController.selected = self


func _on_area_2d_area_entered(area):
	if area.is_in_group("Box"):
		area.get_parent().brokerpos = self.global_position + Vector2(0,33)
		var original_box = area.get_parent()

		for i in range(ConveyerController.destination.size()):

			var target_pos = $entrance.global_position

			var new_box = original_box.duplicate()
			get_tree().current_scene.add_child(new_box)

			
			new_box.global_position = target_pos + Vector2(0, 100)

			
			var tween = create_tween()
			tween.tween_property(
				new_box,
				"global_position",
				ConveyerController.destination[i],
				2.0
			).set_trans(Tween.TRANS_QUAD)

		original_box.queue_free()
		# Replace with function body.


func _on_retrypoint_area_entered(area):
	if area.is_in_group("Box") and area.get_parent().retryattempt>0:
		var tween = create_tween()
		tween.tween_property(area.get_parent(),
			"global_position",
			ConveyerController.dlspos,
			2.0
			).set_trans(Tween.TRANS_QUAD)
			

	
