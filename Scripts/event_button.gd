extends Control
var Levelisoptimised:bool




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Levelisoptimised = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	
	print("dest_size:",ConveyerController.destination.size())
	$"../broker".duplicate_events()
	print(ConveyerController.conveyerInd)
	if  ConveyerController.olderlevels == false && ConveyerController.conveyerInd == ConveyerController.conveyer.size():
		print("i was here!!!")
		$"../Timer".start()
	Level.initialise()
