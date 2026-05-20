extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_timer_timeout():
	$AnimatedSprite2D.play("default") # Replace with function body.


func _on_timer_2_timeout():
	$AnimatedSprite2D/AnimationPlayer.play("suprised") # Replace with function body.
