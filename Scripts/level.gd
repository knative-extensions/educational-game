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

func initialise():
	sinkBoxMatchPresent=true
	sinkUsed=false
	totalbox=0
	nextLevel=false
	dlsUsed=false

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
		var failure_data = analyze_failure()
		show_educational_failure(failure_data, message_display)
		await message_display.show_message_for_duration(4.0)
		message_display.visible = false

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

func show_educational_failure(data: Dictionary, message_display: Control):
	message_display.show_failure_with_lesson(
		data.reason,
		data.hint,
		data.lesson
	)
