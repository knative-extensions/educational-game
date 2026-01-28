extends Node2D

var selected
var events = []
var destination = []
var conveyer = []
var conveyerInd = 0
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
	# SAFETY: prevent crash due to invalid access
	if selected == null:
		return
	if conveyerInd >= conveyer.size():
		return
	if destination == null or conveyerInd >= destination.size():
		return

	conveyer[conveyerInd].set_point_position(0, selected.get_position())
	conveyer[conveyerInd].set_point_position(1, destination[conveyerInd])
	conveyerInd += 1

func send_event():
	print("sending events!")
	self.started = true

	# SAFETY: avoid divide by zero or empty destination
	if conveyerInd == 0:
		return
	if destination == null or destination.size() == 0:
		return

	for n in events.size():
		# SAFETY: ensure event still exists before accessing it
		if not is_instance_valid(events[n]):
			continue

		events[n].sending = true
		var tween = get_tree().create_tween()

		var dest_index = n % conveyerInd
		if dest_index < destination.size():
			tween.tween_property(
				events[n],
				"position",
				destination[dest_index],
				2
			).set_trans(tween.TRANS_LINEAR)

		if dest_index == conveyerInd - 1:
			await tween.finished

	Level.next_level()
