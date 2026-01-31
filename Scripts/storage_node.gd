# Storage node script for the DataRef pattern level
# Handles the storage interaction where large events get stored
# and a reference is created to be sent through the event flow

extends Sprite2D

# Signal when a large payload is stored successfully
signal payload_stored

# State tracking for the storage operation
var has_stored_payload: bool = false
var is_active: bool = true

# Reference to the large box that will be stored
@onready var parent_level = get_parent()


func _ready() -> void:
	# Set up the visual state on start
	modulate = Color(1, 1, 1, 1)
	print("Storage node initialized and ready")


func _process(_delta: float) -> void:
	# Could add subtle animation here like a pulsing effect
	pass


# Handle click input on the storage node via Area2D
func store_large_payload(large_box: Node) -> void:
	if not is_active or has_stored_payload:
		return
	
	print("Storing large payload in cloud storage...")
	
	# Mark that we've stored something
	has_stored_payload = true
	
	# Visual feedback - change color to show storage is used
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.7, 1.0, 0.7, 1), 0.3)
	
	# Hide the large box (it's now in storage)
	if large_box != null:
		var fade_tween = get_tree().create_tween()
		fade_tween.tween_property(large_box, "modulate:a", 0.0, 0.5)
		await fade_tween.finished
		large_box.visible = false
	
	# Notify the level that we've stored the payload
	emit_signal("payload_stored")
	print("Payload stored successfully - reference can now be created")


# Reset the storage node for level restart
func reset_storage() -> void:
	has_stored_payload = false
	is_active = true
	modulate = Color(1, 1, 1, 1)
	print("Storage node reset")
