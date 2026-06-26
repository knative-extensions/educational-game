extends Node
var sinkBoxMatchNeeded=[false,true,true,false,true,true,false]
var sinkBoxMatchPresent
var sinkUsed
var dlsRequired=[false,false,false,true,false,true,false]
var dlsUsed
var transformerRequired = [false,false,false,false,true,false,false]
var transformerUsed
var totalbox= 0 
var nextLevel
var levels=["basicEventFlow","boxClick","multiSink","dlqPattern","transformation_level","multiSinkAndDls","dataRefCutscene"]
var levelind=0

func initialise():
	sinkBoxMatchPresent=true
	sinkUsed=false
	totalbox=0
	nextLevel=false
	dlsUsed=false
	transformerUsed = false

func  next_level():
	
	if sinkUsed: #level 1
		if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind] and not levelind>5:
			print("if next level entered",sinkBoxMatchNeeded,dlsRequired)
			nextLevel=true
		elif dlsRequired[levelind] and sinkBoxMatchNeeded[levelind] and dlsUsed and sinkBoxMatchPresent and not levelind>5:
			nextLevel=true 
		elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent and not dlsRequired[levelind] and not levelind>5:
			print("elif next level entered",sinkBoxMatchNeeded,sinkBoxMatchPresent)
			nextLevel=true 
		elif dlsRequired[levelind] and dlsUsed and not sinkBoxMatchNeeded[levelind] and not levelind>5:
			print("elif dls",dlsUsed) 
			nextLevel=true
		elif transformerRequired[levelind] and transformerUsed and sinkBoxMatchPresent and not levelind >5:
			nextLevel = true  
		elif levelind == 6:
			if totalbox == 2:
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
		message_display.show_message("Failed. Try Again")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
