extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ConveyerController.dlspos = self.global_position# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_mouse_entered():
	$hoverlabel.visible = true 
	

func _on_mouse_exited():
	$hoverlabel.visible = false 
