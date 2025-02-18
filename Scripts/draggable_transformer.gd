extends Area2D

@export var transformerColor: String
var draggable = false
# Called when the node enters the scene tree for the first time.
func _ready():
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

func _on_area_entered(area):
	if area.is_in_group("Box"):
		if area.get_parent().boxType != transformerColor and area.get_parent().sending == true:
			print("make it red")
			area.get_parent().boxType = "Red"
			area.get_parent().set_texture(preload("res://2D Assets/boxes/redBox.png"))
 # Replace with function body.


func _on_mouse_entered():
	if not ConveyerController.dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)
		$Panel.show()


func _on_mouse_exited():
	if not ConveyerController.dragging:
		draggable = false
		scale = Vector2(1, 1)
		$Panel.hide()
