extends Node

# Level configuration arrays
# sinkBoxMatchNeeded: whether the box type must match the sink type
# dlsRequired: whether DLS (Dead Letter Sink) must be used
# storageRequired: whether storage node must be used (for DataRef pattern)
var sinkBoxMatchNeeded = [false, true, true, false, true]
var sinkBoxMatchPresent
var sinkUsed
var dlsRequired = [false, false, false, true, false]
var storageRequired = [false, false, false, false, true]
var storageUsed = false
var dlsUsed
var totalbox = [2, 2, 3]
var nextLevel

# Level scene names in order
var levels = ["basicEventFlow", "boxClick", "multiSink", "dlqPattern", "dataRefPattern"]
var levelind = 0

func initialise():
	sinkBoxMatchPresent = true
	sinkUsed = false
	totalbox = 0
	nextLevel = false
	dlsUsed = false
	storageUsed = false

func next_level():
	# Check win conditions based on level requirements
	if sinkUsed:
		# Basic level - just need sink
		if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind] and not storageRequired[levelind]:
			print("Basic level passed - sink used")
			nextLevel = true
		# Filter level - box type must match
		elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent and not storageRequired[levelind]:
			print("Filter level passed - box matched sink")
			nextLevel = true
		# DLQ level - dead letter sink must be used
		elif dlsRequired[levelind] and dlsUsed:
			print("DLQ level passed - dead letter sink used")
			nextLevel = true
		# DataRef level - storage must be used and reference delivered
		elif storageRequired[levelind] and storageUsed and sinkBoxMatchPresent:
			print("DataRef level passed - storage used and reference delivered")
			nextLevel = true
	
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.z_index = 999 
	if nextLevel:
		print("success")
		message_display.show_message("Success")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
		levelind+=1
		if levelind!=levels.size():
			var next_level_path="res://Scenes/"+levels[levelind]+".tscn"
			get_tree().change_scene_to_file(next_level_path)
			ConveyerController.initialise()
		else:
			print("End of Levels.")
			get_tree().change_scene_to_file("res://Scenes/end_of_all_levels.tscn")
	else:
		print("Failed. Try Again")
		message_display.show_message("Failed. Try Again")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
