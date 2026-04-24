extends Node2D

var localsinkattached: bool = false
var localtransformerattached: bool = false


func _on_anothre_area_entered(area):
	
	if area.is_in_group("Box"):
		var box = area.get_parent()


		if not is_instance_valid(box):
			return

		box.returning = false 

		if localtransformerattached and localsinkattached:
			
			var box_clone = box.duplicate()
			
			
			box_clone.set_meta("is_clone", true)
			
			
			var clone_area = box_clone.get_node_or_null("Area2D")
			if clone_area:
				clone_area.monitoring = false
				clone_area.monitorable = false
			add_child(box_clone)
			box_clone.global_position = box.global_position 
			
			_simple_move(box, $LocalTransformer.global_position)
			_simple_move(box_clone, $LocalSink.global_position)
		
		elif localtransformerattached and !localsinkattached:
			_simple_move(box, $LocalTransformer.global_position)
			
		elif localsinkattached and !localtransformerattached:
			_simple_move(box, $LocalSink.global_position)

func _simple_move(target, target_pos):
	var tween = create_tween()
	
	tween.tween_property(target, "global_position", target_pos, 2).set_trans(Tween.TRANS_LINEAR)
	
	
