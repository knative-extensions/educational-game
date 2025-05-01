extends Node2D

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func _on_blockage_left_area_entered(area: Area2D) -> void:
	ConveyerController.can_send=false
	var areaboxA=$BoxA/Area2D
	var areaboxB=$BoxB/Area2D
	var areadls=$dls/CollisionShape2D
	var spriteA=$BoxA
	var spriteB=$BoxB
	var target_position=areadls.global_position #+ Vector2(40, 30)
	spriteA.global_position=target_position
	spriteB.global_position=target_position+ Vector2(40,0)
