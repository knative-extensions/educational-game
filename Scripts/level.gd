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

# HUD Handling
var hud_scene = preload("res://Scenes/LevelHUD.tscn")
var hud_instance

func _ready():
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	update_hud()

func initialise():
	sinkBoxMatchPresent=true
	sinkUsed=false
	totalbox=0
	nextLevel=false
	dlsUsed=false
	
	# Make sure HUD is visible again if we restarted
	if hud_instance:
		hud_instance.show()
	update_hud()

func update_hud():
	if hud_instance:
		hud_instance.update_display(levelind + 1, levels.size())

func next_level():
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
		update_hud()
		
		if levelind!=levels.size():
			var next_level_path="res://Scenes/"+levels[levelind]+".tscn"
			get_tree().change_scene_to_file(next_level_path)
			ConveyerController.initialise()
		else:
			print("End of Levels.")
			# --- HIDE HUD HERE ---
			if hud_instance:
				hud_instance.hide()
			get_tree().change_scene_to_file("res://Scenes/end_of_all_levels.tscn")
	else:
		print("Failed. Try Again")
		message_display.show_message("Failed. Try Again")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false