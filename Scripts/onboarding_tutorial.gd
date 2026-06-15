extends Node2D

var step = 0
var tutorial_steps = [
	"Welcome! This game teaches Knative Eventing patterns.",
	"This is an Event. Click it to select.",
	"Good! Now click the Sink to create a connection.",
	"Perfect! You created your first event flow.",
	"Now press START to see events move."
]

func _ready():
	show_step(0)

func show_step(index):
	$Message.text = tutorial_steps[index]
	self.visible = true

func _on_next_button_pressed():
	step += 1
	if step < tutorial_steps.size():
		show_step(step)
	else:
		self.visible = false