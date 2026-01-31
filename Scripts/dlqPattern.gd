extends Node2D
@onready var DLS=$dls
@onready var blockagepoint= $Blockage
var dlsclicked = false

func _ready() -> void:
	ConveyerController.can_send = false 
	pass
	
func _process(delta: float) -> void:
	pass
	
func _on_blockage_left_area_entered(area: Area2D) -> void:
	pass
#when DLS is clicked
func _on_dls_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		dlsclicked=true
		#ConveyerController.conveyerInd+=1
		var dlqTrigger=$dlsconveyor
		dlqTrigger.set_point_position(0, Vector2(529,250))
		dlqTrigger.set_point_position(1, DLS.position+Vector2(80,0))


func _on_dls_area_entered(area: Area2D) -> void:
	if area.is_in_group("Box"):
		print("box in DLS")
		Level.dlsUsed = true

#when event get in the blockage area
func _on_area_2d_area_entered(area):
	ConveyerController.can_send=false
	var blockedEvents = ConveyerController.events.duplicate()
	if dlsclicked:
		
		for event in blockedEvents:
			if event == null or not event.is_inside_tree():
				continue  # skip already deleted or invalid nodes
			
			event.sending = true 
			var tween = get_tree().create_tween()
			tween.tween_property(event, "position", DLS.position+Vector2(80,0), 2).set_trans(Tween.TRANS_LINEAR)
			await tween.finished
	else:
		for event in blockedEvents:
			if event == null or not event.is_inside_tree():
				continue  # skip already deleted or invalid nodes
			
			event.sending = true  
			var tween = get_tree().create_tween()
			tween.tween_property(event, "position", blockagepoint.position, 2).set_trans(Tween.TRANS_LINEAR)
			await tween.finished

	 # Replace with function body.
