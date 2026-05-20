extends Node2D

var readyfordataref:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D/RichTextLabel.visible_ratio  = 0 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_timer_timeout():
	$AnimatedSprite2D.play("default") # Replace with function body.


func _on_timer_2_timeout():
	readyfordataref = true
	$AnimatedSprite2D/AnimationPlayer.play("suprised") # Replace with function body.


func _on_kuack_dataref_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("kuack clicked dataref")
			if readyfordataref:
				$Timer3.start()
				$AnimatedSprite2D/RichTextLabel/text.play("textanim")
			# Put your logic here
		


func _on_timer_3_timeout():
	Level.initialise()
	ConveyerController.initialise()
	get_tree().change_scene_to_file("res://Scenes/dataref.tscn") # Replace with function body.
