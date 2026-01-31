extends Sprite2D

@export var expectedType: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	


func _on_area_2d_mouse_entered():
	$Panel.show() # Replace with function body.



func _on_area_2d_mouse_exited():
	$Panel.hide() # Replace with function body.
