extends Line2D

func _ready() -> void:
	print("transformer conveyor ready")
	TransformerConveyerController.setup(self)
	
