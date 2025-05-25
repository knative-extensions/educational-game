extends Area2D

var draggable = false
var bodyref
@export var filterColor: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			ConveyerController.dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("click"):
			ConveyerController.dragging = false
			global_position = get_global_mouse_position()

func _on_mouse_entered() -> void:
	if not ConveyerController.dragging:
		draggable = true
		#scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	if not ConveyerController.dragging:
		draggable = false
		#scale = Vector2(1, 1)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Box"):
		if area.get_parent().boxType != filterColor and area.get_parent().sending == true:
			print("kill it")
			area.get_parent().queue_free()
