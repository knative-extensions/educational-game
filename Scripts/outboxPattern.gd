extends Node2D

@onready var sink = $Sink
@onready var outbox_node = $OutboxNode
@onready var toggle_button = $Control_Toggle/Button
@onready var toggle_label = $Control_Toggle/Button/RichTextLabel
@onready var outbox_visual = $OutboxNode/Sprite2D

var outbox_enabled = false
var events = []

func _ready() -> void:
	# Disable default conveyer controller to handle movement manually
	ConveyerController.can_send = false
	update_outbox_visual()
	
	# Update toggle text
	if toggle_label:
		toggle_label.text = "[center]Outbox: OFF"

func update_outbox_visual():
	if outbox_visual:
		if outbox_enabled:
			outbox_visual.modulate = Color(1, 1, 1, 1) # Full opacity
		else:
			outbox_visual.modulate = Color(0.5, 0.5, 0.5, 0.5) # Dimmed

func _on_toggle_button_pressed() -> void:
	outbox_enabled = !outbox_enabled
	update_outbox_visual()
	if toggle_label:
		if outbox_enabled:
			toggle_label.text = "[center]Outbox: ON"
		else:
			toggle_label.text = "[center]Outbox: OFF"

func _on_start_button_pressed() -> void:
	print("custom start pressed")
	Level.initialise()
	
	# Capture events
	events = ConveyerController.events.duplicate()
	
	if outbox_enabled:
		start_success_flow()
	else:
		start_failure_flow()

func start_failure_flow():
	print("Starting failure flow")
	for event in events:
		if event == null or not is_instance_valid(event): continue
		event.sending = true
		
		var tween = get_tree().create_tween()
		# Move halfway to sink
		var mid_point = (event.position + sink.position) / 2
		tween.tween_property(event, "position", mid_point, 1.0)
		await tween.finished
		
		# Fade out
		var tween_fail = get_tree().create_tween()
		tween_fail.tween_property(event, "modulate:a", 0.0, 0.5)
		await tween_fail.finished
		event.visible = false
		
	# Show failure message
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.show_message("Data Loss! Enable Outbox.")
	await message_display.show_message_for_duration(2.0)
	message_display.queue_free()
	
	Level.next_level()

func start_success_flow():
	print("Starting success flow")
	# First move to Outbox
	for event in events:
		if event == null or not is_instance_valid(event): continue
		event.sending = true
		
		var tween = get_tree().create_tween()
		tween.tween_property(event, "position", outbox_node.position, 1.0)
		await tween.finished
		
	# Store simulation
	await get_tree().create_timer(0.5).timeout
	
	# Then move to Sink
	for event in events:
		if event == null or not is_instance_valid(event): continue
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(event, "position", sink.position, 1.0)
		await tween2.finished
		
	# Wait for sink detection logic (usually Area2D signal in Sink)
	await get_tree().create_timer(1.0).timeout
	Level.next_level()
