extends Node
var sinkBoxMatchNeeded=[false,true,true,false,true,true]
var sinkBoxMatchPresent
var sinkUsed
var dlsRequired=[false,false,false,true,false,true]
var dlsUsed
var transformerRequired = [false,false,false,false,true,false]
var transformerUsed
var totalbox=[2,2,3]
var nextLevel
var levels=["basicEventFlow","boxClick","multiSink","dlqPattern","transformation_level","multiSinkAndDls"]
var levelind=0

func initialise():
	sinkBoxMatchPresent=true
	sinkUsed=false
	totalbox=0
	nextLevel=false
	dlsUsed=false
	transformerUsed = false
	for child in get_children():
		if child is CanvasLayer and child.layer == 10:
			child.queue_free()   
	
	


func  next_level():
	if sinkUsed:
		if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind]:
			print("if next level entered",sinkBoxMatchNeeded,dlsRequired)
			nextLevel=true
		elif dlsRequired[levelind] and sinkBoxMatchNeeded[levelind] and dlsUsed and sinkBoxMatchPresent:
			nextLevel=true
		elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent and not dlsRequired[levelind]:
			print("elif next level entered",sinkBoxMatchNeeded,sinkBoxMatchPresent)
			nextLevel=true
		elif dlsRequired[levelind] and dlsUsed and not sinkBoxMatchNeeded[levelind]:
			print("elif dls",dlsUsed)
			nextLevel=true
		elif transformerRequired[levelind] and transformerUsed and sinkBoxMatchPresent:
			nextLevel = true
	
	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.z_index = 999 
	if nextLevel:
		print("success")
		AudioManager.play_level_clear() 
		message_display.show_message("Success")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
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
		print("Failed. Try Again")
		AudioManager.play_level_fail() 
		apply_fail_effect()
		ConveyerController.set_process(false)
		message_display.show_message("Failed. Try Again")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
		
		


func apply_fail_effect():
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(overlay)
