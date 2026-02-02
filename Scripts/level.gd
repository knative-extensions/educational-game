extends Node

# Configuration: UI Display Names
var level_display_names = {
	"basicEventFlow": "Basic Event Flow",
	"boxClick": "Event Filtering & Interaction",
	"multiSink": "Fan-Out Pattern (Multi-Sink)",
	"dlqPattern": "Dead Letter Queue Pattern"
}

var sinkBoxMatchNeeded = [false, true, true, false]
var sinkBoxMatchPresent
var sinkUsed
var dlsRequired = [false, false, false, true]
var dlsUsed
var totalbox = [2, 2, 3]
var nextLevel
var levels = ["basicEventFlow", "boxClick", "multiSink", "dlqPattern"]
var levelind = 0

var _title_overlay: CanvasLayer

func _ready():
	var OverlayScript = load("res://Scripts/level_title.gd")
	if OverlayScript:
		_title_overlay = OverlayScript.new()
		add_child(_title_overlay)
		# Update the text immediately on load
		_update_level_title()
	else:
		print("Error: Could not load level_title.gd")

func initialise():
	sinkBoxMatchPresent = true
	sinkUsed = false
	totalbox = 0
	nextLevel = false
	dlsUsed = false
	
	# Update the UI whenever the level resets
	_update_level_title()

func next_level():
	# Check Win Conditions based on current level requirements
	if sinkUsed:
		if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind]:
			print("if next level entered", sinkBoxMatchNeeded, dlsRequired)
			nextLevel = true
		elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent:
			print("elif next level entered", sinkBoxMatchNeeded, sinkBoxMatchPresent)
			nextLevel = true
		elif dlsRequired[levelind] and dlsUsed:
			print("elif dls", dlsUsed)
			nextLevel = true
	
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.z_index = 999 
	
	if nextLevel:
		print("success")
		message_display.show_message("Success")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
		
		levelind += 1
		
		if levelind != levels.size():
			var next_level_path = "res://Scenes/" + levels[levelind] + ".tscn"
			get_tree().change_scene_to_file(next_level_path)
			
			if ConveyerController.has_method("initialise"):
				ConveyerController.initialise()
			
			# Reset Level Logic
			initialise()
		else:
			print("End of Levels.")
			get_tree().change_scene_to_file("res://Scenes/end_of_all_levels.tscn")
			
			# Hide the top-left UI on the final screen
			if _title_overlay:
				_title_overlay.set_visible_state(false)
	else:
		print("Failed. Try Again")
		message_display.show_message("Failed. Try Again")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false

func _update_level_title():
	if not _title_overlay: return
	
	# Ensure UI is visible
	_title_overlay.set_visible_state(true)
	
	if levelind < levels.size():
		var internal_name = levels[levelind]
		var display_text = internal_name
		
		if level_display_names.has(internal_name):
			display_text = level_display_names[internal_name]
		
		_title_overlay.update_text("Pattern: " + display_text)
	else:
		_title_overlay.set_visible_state(false)