extends Node
var sinkBoxMatchNeeded=[false,true]
var sinkBoxMatchPresent
var dlsRequired=[false,false]
var dlsUsed
var totalbox
var nextLevel
var levels=["basicEventFlow","boxClick"]
var levelind=0

func initialise():
	sinkBoxMatchPresent=true
	totalbox=0
	nextLevel=false

func  next_level():
	if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind]:
		print("if next level entered",sinkBoxMatchNeeded,dlsRequired)
		nextLevel=true
	elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent:
		print("elif next level entered",sinkBoxMatchNeeded,sinkBoxMatchPresent)
		nextLevel=true
	
	if nextLevel:
		print("success")
		levelind+=1
		if levelind!=levels.size():
			var next_level_path="res://Scenes/"+levels[levelind]+".tscn"
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("End of Levels.")
	else:
		print("Failed. Try Again")
