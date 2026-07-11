extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	print("restart clicked")
	# Reinitialise ConveyerController BEFORE reloading the scene so that
	# autoload state is clean when the new scene tree is built.  Previously
	# ConveyerController.initialise() was called after reload_current_scene(),
	# which meant it executed in the context of the freshly-loaded scene and
	# could race with _ready() callbacks that read ConveyerController fields
	# (e.g. setup() appending to conveyer[]).  Calling it first guarantees a
	# blank slate for the incoming scene.
	ConveyerController.initialise()
	Level.initialise()
	get_tree().reload_current_scene()
