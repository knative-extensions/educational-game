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
	self.started = false
	# DON'T clear events here boxes add themselves in _ready()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.can_send and not self.started and self.destination != null:
		self.send_event()
	pass

func create_conveyor():
	# SAFETY CHECK for BasicEventFlow (1 conveyor scene)
	# Allow dynamic creation for MultiSink (3+ conveyor scene)
	if conveyerInd >= conveyer.size():
		if conveyer.size() == 0:
			print("ERROR: No conveyors available!")
			return
		
		# Only allow dynamic creation if we have 3+ conveyors (MultiSink level)
		if conveyer.size() >= 3:
			# MultiSink create more conveyors dynamically
			var new_conveyor = conveyer[0].duplicate()
			get_tree().current_scene.add_child(new_conveyor)
			new_conveyor.z_index = -1
			conveyer.append(new_conveyor)
			print("Created new conveyor, total: ", conveyer.size())
		else:
			# BasicEventFlow stop here to prevent crash
			print("No more conveyors available (max ", conveyer.size(), ")")
			return
	
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
