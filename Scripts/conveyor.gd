extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("conveyor ready")
	ConveyerController.setup(self)
	
