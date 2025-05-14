extends Line2D
@export var conveyorIndex: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("conveyor ready", conveyorIndex)
	ConveyerController.setup(self)
	
