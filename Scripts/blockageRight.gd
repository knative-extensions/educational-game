extends Area2D
var movement
var canMove
@onready var BlockageLeft = get_node("../BlockageLeft")
func _process(delta: float) -> void:
	if movement:
		position.x-=100*delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Block"):
		movement=false
		canMove=false



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("Clicked on right blockage")
		canMove=true
		BlockageLeft.canMove=true
