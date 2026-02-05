extends Control

@onready var button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Disable START button initially - needs route to be connected first
	button.disabled = true
	button.modulate = Color(0.5, 0.5, 0.5, 1.0)  # Gray out when disabled


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called by SinkClick when a route is connected
func enable_start() -> void:
	button.disabled = false
	button.modulate = Color(1.0, 1.0, 1.0, 1.0)  # Normal color when enabled

func _on_button_pressed() -> void:
	Level.initialise()
	ConveyerController.can_send = true
