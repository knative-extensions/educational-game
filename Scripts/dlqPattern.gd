extends Node2D
@onready var DLS=$dls
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func _on_blockage_left_area_entered(area: Area2D) -> void:
	ConveyerController.can_send=false
	var blockedEvents=ConveyerController.events.duplicate()
	
	for event in blockedEvents:
		if event == null or not event.is_inside_tree():
			continue  # skip already deleted or invalid nodes
			
		event.sending = true  # Assuming this is your custom property
		var tween = get_tree().create_tween()
		tween.tween_property(event, "position", DLS.position+Vector2(80,0), 2).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		
