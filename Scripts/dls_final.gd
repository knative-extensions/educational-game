extends Node2D

func _ready() -> void:
	hide()
func _process(delta: float) -> void:
	pass
func on_blockage():
	show()
