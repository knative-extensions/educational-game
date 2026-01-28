extends Node2D

@onready var sink = $Sink
@onready var data_store_node = $DataStoreNode
@onready var toggle_button = $Control_Toggle/Button
@onready var toggle_label = $Control_Toggle/Button/RichTextLabel
@onready var data_store_visual = $DataStoreNode/Sprite2D

var dataref_enabled = false
var events = []

func _ready() -> void:
	# Disable default conveyer controller to handle movement manually
	ConveyerController.can_send = false
	update_dataref_visual()
	
	# Update toggle text
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
	print("custom start pressed")
	Level.initialise()
	
	# Capture events
	events = ConveyerController.events.duplicate()
	
	if dataref_enabled:
		start_success_flow()
	else:
		start_failure_flow()

func start_failure_flow():
	print("Starting failure flow (DataRef OFF)")
	for event in events:
		if event == null or not is_instance_valid(event): continue
		event.sending = true
		
		# Make event look large/heavy
		event.scale = Vector2(1.2, 1.2)
		
		var tween = get_tree().create_tween()
		# Move slowly to sink (simulating network congestion with large payload)
		tween.tween_property(event, "position", sink.position, 3.0) # Slow duration
		await tween.finished
		
		# Fail at sink
		var tween_fail = get_tree().create_tween()
		tween_fail.tween_property(event, "modulate", Color(1, 0, 0, 0), 0.5) # Turn red and fade
		await tween_fail.finished
		event.visible = false
		
	# Show failure message
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.show_message("Payload too large! Use DataRef.")
	await message_display.show_message_for_duration(2.0)
	message_display.queue_free()
	
	Level.next_level()

func start_success_flow():
	print("Starting success flow (DataRef ON)")
	# First move to Data Store to deposit payload
	for event in events:
		if event == null or not is_instance_valid(event): continue
		event.sending = true
		event.scale = Vector2(1.2, 1.2) # Large initially
		
		var tween = get_tree().create_tween()
		tween.tween_property(event, "position", data_store_node.position, 1.0)
		await tween.finished
		
		# "Deposit" payload animation
		# Shake or flash?
		var tween_deposit = get_tree().create_tween()
		tween_deposit.tween_property(event, "scale", Vector2(0.5, 0.5), 0.5) # Shrink to Reference
		tween_deposit.parallel().tween_property(event, "modulate", Color(0.5, 1, 0.5), 0.5) # Turn Greenish (Ref)
		await tween_deposit.finished
		
	# Store simulation pause
	await get_tree().create_timer(0.3).timeout
	
	# Then move Ref to Sink (Fast)
	for event in events:
		if event == null or not is_instance_valid(event): continue
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(event, "position", sink.position, 0.8) # Fast
		await tween2.finished
		
	# Wait for sink logic
	await get_tree().create_timer(1.0).timeout
	Level.next_level()
