extends Node2D


# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_send_pressed():
	$BoxA.global_position = $broker.global_position
	await get_tree().create_timer(2.0).timeout
	$BoxB.global_position = $broker.global_position
