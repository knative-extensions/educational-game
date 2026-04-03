extends Control

var levels_completed = []

func _ready():
	var config = ConfigFile.new()
	config.load("user://progress.save")
	
	for i in Level.levels.size():
		levels_completed.append(config.get_value("progress", str(i), false))

	for i in Level.levels.size():
		var button = $LevelButtons.get_child(i)
		button.disabled = !levels_completed[i] && i > 0
		
		if levels_completed[i]:
			button.icon = preload("res://2D Assets/boxes/greenBox.png")

func _on_level_button_pressed(level_index):
	Level.levelind = level_index
	get_tree().change_scene_to_file("res://Scenes/" + Level.levels[level_index] + ".tscn")

func _on_reset_progress_pressed():
	var config = ConfigFile.new()
	for i in Level.levels.size():
		config.set_value("progress", str(i), false)
	config.save("user://progress.save")
	get_tree().reload_current_scene()