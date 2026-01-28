extends Node2D

@onready var sink = $Sink
@onready var data_store_node = $DataStoreNode
@onready var toggle_button = $Control_Toggle/Button
@onready var toggle_label = $Control_Toggle/Button/RichTextLabel
@onready var data_store_visual = $DataStoreNode/Sprite2D

# The main payload box
@onready var event_box = $BoxA 

var dataref_enabled = false

func _ready() -> void:
	# Disable default conveyer controller to handle movement manually for this pattern level
	ConveyerController.can_send = false
	update_dataref_visual()
	
	if toggle_label:
		toggle_label.text = "[center]DataRef: OFF"

func update_dataref_visual():
	if data_store_visual:
		if dataref_enabled:
			data_store_visual.modulate = Color(1, 1, 1, 1) # Full opacity
		else:
			data_store_visual.modulate = Color(0.5, 0.5, 0.5, 0.5) # Dimmed

func _on_toggle_button_pressed() -> void:
	dataref_enabled = !dataref_enabled
	update_dataref_visual()
	if toggle_label:
		if dataref_enabled:
			toggle_label.text = "[center]DataRef: ON"
		else:
			toggle_label.text = "[center]DataRef: OFF"

func _on_start_button_pressed() -> void:
	print("Start flow: DataRef is " + str(dataref_enabled))
	Level.initialise()
	
	if event_box == null:
		print("Error: Event Box not found!")
		return
	
	if dataref_enabled:
		start_success_flow()
	else:
		start_failure_flow()

func start_failure_flow():
	print("Starting failure flow (DataRef OFF)")
	
	var event = event_box
	event.visible = true
	event.modulate = Color(1, 1, 1, 1) # Reset color
	
	# Initial Setup: Simulating Large Payload
	event.scale = Vector2(1.2, 1.2)
	var initial_pos = event.position
	var initial_scale = event.scale
	
	# Move slowly to sink (simulating network congestion with large payload)
	var tween = get_tree().create_tween()
	tween.tween_property(event, "position", sink.position, 3.0) 
	await tween.finished
	
	# Fail at sink (Payload too large/heavy)
	var tween_fail = get_tree().create_tween()
	tween_fail.tween_property(event, "modulate", Color(1, 0, 0, 0), 0.5) # Turn red and fade out
	await tween_fail.finished
	
	# Reset position for retry (invisible)
	event.position = initial_pos
	event.scale = initial_scale
	event.visible = true 
	event.modulate = Color(1, 1, 1, 1)
	
	# Ensure Sink is marked as NOT used successfully
	Level.sinkUsed = false
	
	# Show failure message
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.show_message("Payload too large! Use DataRef.")
	await message_display.show_message_for_duration(2.0)
	message_display.queue_free()
	
	# Trigger Level Check -> This allows the Level system to register failure
	# The Level script will see sinkUsed=false and show "Failed. Try Again"
	Level.next_level()

func start_success_flow():
	print("Starting success flow (DataRef ON)")
	
	var event = event_box
	event.visible = true
	event.modulate = Color(1, 1, 1, 1)
	var initial_pos = event.position
	
	# Step 1: Simulating Large Payload initially
	event.scale = Vector2(1.2, 1.2) 
	
	# Step 2: Offload Data to Store (Claim Check Pattern)
	var tween = get_tree().create_tween()
	tween.tween_property(event, "position", data_store_node.position, 1.0)
	await tween.finished
	
	# Step 3: Turn into Reference (Small Token)
	var tween_deposit = get_tree().create_tween()
	tween_deposit.tween_property(event, "scale", Vector2(0.5, 0.5), 0.5) # Shrink to Reference size
	tween_deposit.parallel().tween_property(event, "modulate", Color(0.5, 1, 0.5), 0.5) # Turn Greenish (Valid Reference)
	await tween_deposit.finished
	
	# Step 4: Move Reference to Sink (Fast and Lightweight)
	var tween_ref = get_tree().create_tween()
	tween_ref.tween_property(event, "position", sink.position, 0.8) # Fast move
	await tween_ref.finished
	
	# Step 5: Sink Receives Reference -> Retrieves Data from Store
	# Create a visual for the data retrieval
	var retrieval_pkg = Sprite2D.new()
	# Use the texture of the event box or a generic box
	retrieval_pkg.texture = event.get_node("Sprite2D").texture if event.has_node("Sprite2D") else preload("res://2D Assets/boxes/blueBox.png")
	retrieval_pkg.scale = Vector2(0.3, 0.3)
	retrieval_pkg.position = data_store_node.position
	retrieval_pkg.modulate = Color(0, 0.5, 1, 0.8) # Data Color
	add_child(retrieval_pkg)
	
	# Animate Data moving from Store to Sink
	var tween_retrieve = get_tree().create_tween()
	tween_retrieve.tween_property(retrieval_pkg, "position", sink.position, 0.6)
	tween_retrieve.parallel().tween_property(retrieval_pkg, "scale", Vector2(1.0, 1.0), 0.6) # Restore full size
	await tween_retrieve.finished
	
	retrieval_pkg.queue_free()
	
	# Mark as Success
	Level.sinkUsed = true
	
	# Reset event for visual cleanliness (optional)
	event.modulate = Color(1, 1, 1, 1)
	
	await get_tree().create_timer(1.0).timeout
	Level.next_level()
