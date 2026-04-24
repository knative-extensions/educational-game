extends Area2D
func _input_event(viewport, event, shape_idx):
	if event.is_pressed():
		$"../LocalConveyorA".set_point_position(1,self.position)
		self.get_parent().localtransformerattached = true
	


func _on_area_entered(area):
	if area.is_in_group("Box") and not area.get_parent().returning:
		var box = area.get_parent()

		Level.transformerUsed = true


		box.boxType = "RedTriangle"
		box.set_texture(preload("res://2D Assets/boxes/blueBoxPinkTriangle.png"))
		print("Transformed box to: ", box.boxType)

		box.returning = true


		var tween = get_tree().create_tween()
		tween.tween_property(box, "global_position",$"..".position, 2.0).set_trans(Tween.TRANS_LINEAR)
