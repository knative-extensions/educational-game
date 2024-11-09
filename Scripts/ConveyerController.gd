extends Node2D

var selected
var events = []
var destination
var conveyer
var dragging
var sendingEnd = false
var can_send = false
var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.can_send and not self.started and self.destination != null:
		self.send_event()
	pass

func create_conveyor():
	conveyer.set_point_position(0, selected.get_position())
	conveyer.set_point_position(1, destination.get_position())
	
func send_event():
	print("sending events!")
	self.started = true
	for n in events.size():
		events[n].get_child(0).sending = true
		var tween = get_tree().create_tween()
		tween.tween_property(events[n], "position", destination.get_position(), 2).set_trans(tween.TRANS_LINEAR)
		await tween.finished
