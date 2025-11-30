extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var confetti_textures = [
		load("res://2D Assets/confetti/confetti1.png"), 
		load("res://2D Assets/confetti/confetti2.png"),
		load("res://2D Assets/confetti/confetti3.png")]
	
	var count = 130
	
	var rng =  RandomNumberGenerator.new()
	rng.randomize()
	var screen_size = get_viewport_rect().size
	
	for i in range(count):
		var sprite = Sprite2D.new()
		sprite.texture = confetti_textures[rng.randi_range(0,confetti_textures.size()-1)]
		sprite.position  = Vector2(rng.randf_range(0,screen_size.x),0)
		
		var scale = rng.randf_range(0.09,0.26)
		sprite.scale = Vector2(scale, scale)
		
		
		
		add_child(sprite)
		
		
		
		
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
