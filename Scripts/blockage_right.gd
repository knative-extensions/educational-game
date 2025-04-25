extends Sprite2D
var movement=true
func _process(delta):
	if movement:
		position.x -= 100 * delta # Move left by 100 pixels per second
func on_blockage():
	movement=false
