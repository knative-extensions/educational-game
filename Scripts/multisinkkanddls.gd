extends Node2D

@onready var dlspoint = $dls.position
var dlsclicked:bool = false
@onready var DLS = $dls
@onready var blockagepoint = $Blockage.position
var animationhappened:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Level.levelind = 5
	ConveyerController.olderlevels = false# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_dls_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		dlsclicked = true
		var dlqTrigger=$dlsConveyor
		dlqTrigger.set_point_position(0, Vector2(544,230))
		dlqTrigger.set_point_position(1, DLS.position+Vector2(80,0))




func _on_area_2d_area_entered(area):
	if area.is_in_group("Box"):
		if not animationhappened:
			$Blockage/AnimationPlayer.play("crush")
			animationhappened = true
		if dlsclicked:
			var tween = get_tree().create_tween()
			tween.tween_property(area.get_parent(), "position", dlspoint + Vector2(60,0), 2).set_trans(Tween.TRANS_LINEAR)
			await tween.finished # Replace with function body.
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(area.get_parent(), "position", blockagepoint, 2).set_trans(Tween.TRANS_LINEAR)
			await tween.finished
			
		
		
		
		


func _on_timer_timeout():
	Level.next_level()
	# Replace with function body.


func _on_dls_area_entered(area):
	if area.is_in_group("Box"):
		Level.dlsUsed = true# Replace with function body.
