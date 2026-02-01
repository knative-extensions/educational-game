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
