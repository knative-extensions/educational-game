extends Area2D

func _ready() -> void:
	pass

func _input_event(viewport, event, shape_idx) -> void:
	if event.is_pressed():
		get_parent().on_click()
