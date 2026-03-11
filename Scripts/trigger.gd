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
	self.events = []
	self.started = false
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func create_conveyor():

	conveyer[conveyerInd].set_point_position(0, selected.get_position())
	conveyer[conveyerInd].set_point_position(1, destination[conveyerInd])
	AudioManager.play_construction()
	conveyerInd+=1
	
