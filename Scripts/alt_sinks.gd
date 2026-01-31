extends Sprite2D
@export var sourcePosition : Vector2
@export var sinkType : String 
@export var sending = false
var alreadyaconveyer = false

func _ready() -> void:
	
	if sinkType == "Red":
		self.set_texture(preload("res://2D Assets/sinks/redSink.png"))
	if sinkType == "Green":
		self.set_texture(preload("res://2D Assets/sinks/greenSink.png"))
	if sinkType == "Blue":
		self.set_texture(preload("res://2D Assets/sinks/sink.png"))

func _input_event(viewport, event, shape_idx) -> void:
	print(event)
	if event.is_pressed():
		self.on_click()
		
func on_click():
	if ConveyerController.source_is_ready and !alreadyaconveyer:
		print("Conveyer_is_added")
		alreadyaconveyer = true
		create_conveyor(sourcePosition, self.position)

func create_conveyor(start_position: Vector2, end_position: Vector2) -> void:

	var conveyer_scene = load("res://Scenes/conveyerline.tscn")
	var conveyor = conveyer_scene.instantiate()
	
	self.get_parent().add_child(conveyor)
	ConveyerController.alt_sinks.append(self)
	conveyor.add_point(start_position)  
	conveyor.add_point(end_position)  

	




func _on_area_2d_mouse_entered():
	$Panel.show() # Replace with function body.


func _on_area_2d_mouse_exited():
	$Panel.hide() # Replace with function body.
