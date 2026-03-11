extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input_event(viewport, event, shape_idx) -> void:
	if event.is_pressed():
		get_parent().on_click()
