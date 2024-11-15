extends Sprite2D


const event_script = preload("res://Scripts/event_box.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_event("")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_event(color: String) -> void:
	var event = Sprite2D.new()
	event.texture = load("res://2D Assets/boxes/redBox.png")
	var area = Area2D.new()
	area.shape = RectangleShape2D.new()
	area.shape.set_size(Vector2(1, 1))
	event.position = self.position
	area.set_script(event_script)
	event.add_child(area)
	self.add_child(event)
