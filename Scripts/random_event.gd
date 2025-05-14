extends Sprite2D
@export var boxType: String
@export var sending = false

var box_types = ["Red", "Green", "Blue"]

func _ready() -> void:

	print("event ready")
	print("event is color", boxType)
	boxType = box_types[randi() % box_types.size()]
	ConveyerController.events.append(self)
	
	if boxType=="Red":
		self.set_texture(preload("res://2D Assets/boxes/redBox.png"))
	if boxType == "Green":
		self.set_texture(preload("res://2D Assets/boxes/greenBox.png"))
	if boxType == "Blue":
		self.set_texture(preload("res://2D Assets/boxes/blueBox.png"))





# Called every frame. 'delta' is the elapsed time since the previous frame.
