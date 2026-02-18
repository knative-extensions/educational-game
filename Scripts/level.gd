extends Node
var sinkBoxMatchNeeded=[false,true,true,false]
var sinkBoxMatchPresent
var sinkUsed
var dlsRequired=[false,false,false,true]
var dlsUsed
var totalbox=[2,2,3]
var nextLevel
var levels=["basicEventFlow","boxClick","multiSink","dlqPattern"]
var levelind=0
var tutorial_lines = []
var step_labels = []

func initialise():
	sinkBoxMatchPresent=true
	sinkUsed=false
	totalbox=0
	nextLevel=false
	dlsUsed=false
	clear_tutorial_lines()
	clear_step_labels()
	
func _ready():
	_create_help_button()
	get_tree().node_added.connect(_on_node_added)
	# Check if already loaded (for first run)
	var current = get_tree().current_scene
	if current and current.name == "basicEventFlow":
		_spawn_tutorial_lines(current)
		_create_tutorial_steps(current)

func _process(_delta):
	if levelind == 0 and step_labels.size() >= 2:
		var lbl1 = step_labels[0]
		var lbl2 = step_labels[1]
		if is_instance_valid(lbl1) and is_instance_valid(lbl2):
			if ConveyerController.selected == null:
				lbl1.visible = true
				lbl2.visible = false
			else:
				lbl1.visible = false
				lbl2.visible = true

func _on_node_added(node):
	if node.name == "basicEventFlow":
		# Wait a frame for children to be ready
		await get_tree().process_frame
		_spawn_tutorial_lines(node)
		_create_tutorial_steps(node)

func _spawn_tutorial_lines(scene_root):
	print("Spawning tutorial lines for Level 1...")
	# Load the connector line scene
	var line_scene = load("res://Scenes/ConnectorLine.tscn")
	if not line_scene: return

	# Find nodes (hardcoded names based on basicEventFlow.tscn)
	var box_a = scene_root.get_node_or_null("BoxA")
	var box_b = scene_root.get_node_or_null("BoxB") 
	var sink = scene_root.get_node_or_null("Sink")
	
	# Connect BoxA -> Sink
	if box_a and sink:
		var line1 = line_scene.instantiate()
		scene_root.add_child(line1)
		line1.setup(box_a, sink)
		tutorial_lines.append(line1)
		
	# Connect BoxB -> Sink
	if box_b and sink:
		var line2 = line_scene.instantiate()
		scene_root.add_child(line2)
		line2.setup(box_b, sink)
		tutorial_lines.append(line2)

func clear_tutorial_lines():
	for line in tutorial_lines:
		if is_instance_valid(line):
			line.fade_out()
	tutorial_lines.clear()

func _create_tutorial_steps(scene_root):
	var box_a = scene_root.get_node_or_null("BoxA")
	var sink = scene_root.get_node_or_null("Sink")
	
	if not box_a or not sink: return
	
	var label1 = Label.new()
	label1.text = "1. Click a Box to Select"
	# Move further left to avoid overlap with the box
	label1.position = box_a.global_position + Vector2(-400, -30)
	scene_root.add_child(label1)
	step_labels.append(label1)
	
	var label2 = Label.new()
	label2.text = "2. Now click the Sink"
	# Move much further left to clear the sink graphic (was -350, now -550)
	label2.position = sink.global_position + Vector2(-550, 0)
	scene_root.add_child(label2)
	step_labels.append(label2)
	
	# Style labels
	for lbl in step_labels:
		lbl.add_theme_font_size_override("font_size", 28)
		lbl.add_theme_color_override("font_color", Color(1, 0.2, 0.2)) # High contrast red

func clear_step_labels():
	for lbl in step_labels:
		if is_instance_valid(lbl):
			var tween = create_tween()
			tween.tween_property(lbl, "modulate:a", 0.0, 0.3)
			tween.finished.connect(lbl.queue_free)
	step_labels.clear()

func _create_help_button():
	# Create a CanvasLayer so button stays on top of everything
	var canvas = CanvasLayer.new()
	add_child(canvas)
	
	var help_btn = Button.new()
	help_btn.text = "?"
	help_btn.name = "GlobalHelpButton"
	
	# Style the button to look like a circle/help icon
	help_btn.custom_minimum_size = Vector2(40, 40)
	help_btn.position = Vector2(get_viewport().get_visible_rect().size.x - 60, 20) # Top right
	
	# Connect signal
	help_btn.pressed.connect(_on_help_pressed)
	
	canvas.add_child(help_btn)

func _on_help_pressed():
	print("Help button pressed!")
	# Try access via singleton name directly first (if autoloaded)
	if has_node("/root/TutorialManager"):
		get_node("/root/TutorialManager").open_glossary()
	else:
		print("CRITICAL ERROR: TutorialManager not found in /root. Please add 'Scripts/TutorialManager.gd' to Project Settings -> Autoload as 'TutorialManager'")

func  next_level():
	if sinkUsed:
		if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind]:
			print("if next level entered",sinkBoxMatchNeeded,dlsRequired)
			nextLevel=true
		elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent:
			print("elif next level entered",sinkBoxMatchNeeded,sinkBoxMatchPresent)
			nextLevel=true
		elif dlsRequired[levelind] and dlsUsed:
			print("elif dls",dlsUsed)
			nextLevel=true
	
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.layer = 100 
	if nextLevel:
		print("success")
		AudioManager.play_level_clear() 
		message_display.show_message("Success")
		await message_display.dismissed
		levelind+=1
		if levelind!=levels.size():
			# CRITICAL FIXInitialize BEFORE changing scene, not after!
			ConveyerController.initialise()
			var next_level_path="res://Scenes/"+levels[levelind]+".tscn"
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("End of Levels.")
			get_tree().change_scene_to_file("res://Scenes/end_of_all_levels.tscn")
	else:
		var failure_data = analyze_failure()
		show_educational_failure(failure_data, message_display)
		AudioManager.play_level_fail() 
		await message_display.dismissed

func analyze_failure() -> Dictionary:
	var reason = ""
	var hint = ""
	var lesson = ""
	
	if not sinkUsed:
		reason = "No events were delivered to any sink"
		hint = "Click an event to select it, then click a sink to route it"
		lesson = "In Knative, events must be routed from sources to sinks through triggers"
	
	elif sinkBoxMatchNeeded[levelind] and not sinkBoxMatchPresent:
		reason = "Wrong event type delivered to sink"
		hint = "Use filters to match event colors with sink colors"
		lesson = "Knative Triggers use filters to ensure events reach the correct subscribers based on event attributes"
	
	elif dlsRequired[levelind] and not dlsUsed:
		reason = "Failed events were not routed to Dead Letter Sink"
		hint = "Click the DLS to catch events that hit the blockage"
		lesson = "Dead Letter Sinks prevent data loss by catching events that fail to process"
	
	return {
		"reason": reason,
		"hint": hint,
		"lesson": lesson
	}

func show_educational_failure(data: Dictionary, message_display):
	message_display.show_failure_with_lesson(
		data.reason,
		data.hint,
		data.lesson
	)
