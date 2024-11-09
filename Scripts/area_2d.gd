extends Area2D

@export var boxType: String
@export var sending = false

func _ready() -> void:
	ConveyerController.events.append(get_parent())

func _input_event(viewport, event, shape_idx) -> void:
	if event.is_pressed():
		self.on_click()
		
func on_click():
	print("hi")
	ConveyerController.selected = get_parent()
