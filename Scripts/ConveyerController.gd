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
	self.selected = null
	self.events = []
	self.destination = []
	self.conveyer = []
	self.conveyerInd = 0
	self.dragging = null
	self.sendingEnd = false
	self.can_send = false
	self.started = false

func setup(conveyer) -> void:
	self.conveyer.append(conveyer)
	self.can_send = false
	self.sendingEnd = false
	self.events = []
	self.started = false
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.can_send and not self.started and self.destination != null:
		self.send_event()
	pass

func create_conveyor():
	if conveyer.size() == 0:
		print("ERROR: No conveyor Line2D found in scene!")
		return
		
	# We use min() to ensure we don't go out of bounds of the actual Line2D nodes
	# but we let conveyerInd grow so that destination and events indexing works.
	var line_idx = min(conveyerInd, conveyer.size() - 1)
	
	conveyer[line_idx].set_point_position(0, selected.get_position())
	conveyer[line_idx].set_point_position(1, destination[conveyerInd])
	
	conveyerInd += 1

	conveyer[conveyerInd].set_point_position(0, selected.get_position())
	conveyer[conveyerInd].set_point_position(1, destination[conveyerInd])
	AudioManager.play_construction()
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
