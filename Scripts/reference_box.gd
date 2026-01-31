# Reference box script for DataRef pattern
# This small event represents a reference to data stored elsewhere
# It travels through the event flow instead of the large payload

extends Sprite2D

@export var boxType: String = "Reference"
@export var sending: bool = false

# Reference to the storage location (for educational display)
var storage_ref: String = "cloud://storage/large-payload-001"


func _ready() -> void:
	print("Reference box ready")
	# Don't add to events here - the level script will add us when visible


func _input_event(_viewport, event, _shape_idx) -> void:
	if event.is_pressed():
		self.on_click()


func on_click() -> void:
	print("Reference box selected")
	ConveyerController.selected = self
