extends Node2D

@export var transforming_event:String

# Called when the node enters the scene tree for the first time.
func _ready():
	ConveyerController.transformerpos = self.global_position # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_parent().eventType !=  transforming_event:
		area.get_parent().eventType = transforming_event
	
	var tween = create_tween()
	tween.tween_property(area.get_parent(),"global_position",area.get_parent().brokerpos - Vector2(0,40),2).set_trans(Tween.TRANS_LINEAR)	# Replace with function body.
