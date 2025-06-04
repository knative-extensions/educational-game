extends Sprite2D

@export var boxType: String
@export var sending = false

func _ready() -> void:
	print("event ready")
	print("event is color", boxType)
	ConveyerController.events.append(self)

func _input_event(viewport, event, shape_idx) -> void:
	print(event)
	if event.is_pressed():
		self.on_click()
		
func on_click():
	print("hi")
	ConveyerController.selected = self




func _on_area_2d_mouse_entered():
	$Panel.show() # Replace with function body.


func _on_area_2d_mouse_exited():
	$Panel.hide() # Replace with function body.
