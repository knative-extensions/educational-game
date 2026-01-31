# Large event box script for DataRef pattern
# This represents a payload that's too large to send directly
# It must be stored in external storage first

extends Sprite2D

@export var boxType: String = "Large"
@export var payload_size: int = 50  # MB - represents a large file

# Large boxes cannot be sent directly - visual indicator
var can_be_conveyed: bool = false


func _ready() -> void:
	print("Large payload box ready")
	print("Payload size: ", payload_size, " MB - too large to send directly!")
	print("This must be stored in cloud storage first")


func _input_event(_viewport, event, _shape_idx) -> void:
	if event.is_pressed():
		self.on_click()


func on_click() -> void:
	print("Large box clicked")
	if not can_be_conveyed:
		print("Cannot send directly - payload too large!")
		print("Click on the Storage Node to store this payload first")
	else:
		ConveyerController.selected = self
