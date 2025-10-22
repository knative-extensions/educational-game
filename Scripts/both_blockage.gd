extends Node2D

var consumed 
# Called when the node enters the scene tree for the first time.
func _ready():
	consumed = false# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("clicked on right blockage")
		


func _on_area_2d_area_entered(area):
	if( consumed == false):
		$AnimationPlayer.play("crush") 
		consumed = true
		# Replace with function body.
