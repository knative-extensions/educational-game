extends Area2D
var movement

func _process(delta: float) -> void:
	if movement:
		position.x+=100*delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Block"):
		print("Collision detected.")
		movement=false


func _on_button_pressed() -> void:
	movement=true
