extends Button

func _ready():
	disabled = true
	ConveyerController.connect("destination_count_changed", _on_connection_changed)

func _on_connection_changed(count):
	disabled = count == 0
