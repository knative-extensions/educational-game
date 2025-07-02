extends Area2D
var movement
var canMove
@onready var BlockageRight = get_node("../BlockageRight")
func _process(delta: float) -> void:
	if movement:
		position.x+=100*delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Block"):
		print("Collision detected.")
		movement=false
		canMove=false


func _on_button_pressed() -> void:
	ConveyerController.can_send=true
	movement=true
	BlockageRight.movement=true

#when left blockage is clicked
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("Clicked on left blockage")
		canMove=true
		BlockageRight.canMove=true
