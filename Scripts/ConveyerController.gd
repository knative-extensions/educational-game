extends Node2D

var selected
var destination
var conveyer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_conveyor():
	conveyer.set_point_position(0, selected.get_position())
	conveyer.set_point_position(1, destination.get_position())
	var tween = get_tree().create_tween()
	tween.tween_property(selected, "position", destination.get_position(), 2).set_trans(tween.TRANS_LINEAR)
