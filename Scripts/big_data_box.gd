extends Area2D

var dragging = false
var offset = Vector2.ZERO # distance between mouse and box

func _ready():
	input_pickable = true 

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# calculate offset
				dragging = true
				offset = global_position - get_global_mouse_position()
			else:
				# Drag stop
				dragging = false

func _process(delta):
	if dragging:
		# new mouse pos + offset
		global_position = get_global_mouse_position() + offset
