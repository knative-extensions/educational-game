extends Node2D

var selected
var events = []
var destination = []
var conveyer = []
var conveyerInd=0
var dragging
var sendingEnd = false
var can_send = false
var started = false

func initialise():
	self.selected
	self.events = []
	self.destination = []
	self.conveyer = []
	self.conveyerInd = 0
	self.dragging
	self.sendingEnd = false
	self.can_send = false
	self.started = false

func setup(conveyer) -> void:
	self.conveyer.append(conveyer)
	self.can_send = false
	self.sendingEnd = false
	self.started = false
	self.events = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.can_send and not self.started and self.destination != null:
		self.send_event()
	pass

func create_conveyor():
	conveyer[conveyerInd].set_point_position(0, selected.get_position())
	conveyer[conveyerInd].set_point_position(1, destination[conveyerInd])
	conveyerInd+=1
	
func send_event():
	print("sending events!")
	self.started = true
	if conveyerInd!=0:
		for n in events.size():
			events[n].sending = true
			var tween = get_tree().create_tween()
			tween.tween_property(events[n], "position", destination[n%conveyerInd], 2).set_trans(tween.TRANS_LINEAR)
			if n%conveyerInd==conveyerInd-1:
				await tween.finished
	Level.next_level()
