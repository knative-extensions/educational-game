extends Node

var current_tutorial: Dictionary = {}
var tutorials_completed: Dictionary = {}
var show_tutorials: bool = true
var current_step: int = 0

signal tutorial_started(level: String)
signal tutorial_step_completed(step: String)
signal tutorial_finished(level: String)

func start_level_tutorial(level_name: String):
	if tutorials_completed.get(level_name, false):
		return
	
	var tutorial_path = "res://tutorial_data/" + level_name + ".json"
	var tutorial_file = FileAccess.open(tutorial_path, FileAccess.READ)
	if tutorial_file:
		var tutorial_text = tutorial_file.get_as_text()
		current_tutorial = JSON.parse_string(tutorial_text)
		current_step = 0
		emit_signal("tutorial_started", level_name)
		show_current_step()

func show_current_step():
	if current_step >= current_tutorial.steps.size():
		finish_tutorial()
		return
	
	var step = current_tutorial.steps[current_step]
	show_tooltip(step.text, step.get("highlight", ""))

func show_tooltip(text: String, highlight_target: String = ""):
	var tooltip = preload("res://Scenes/TutorialTooltip.tscn").instantiate()
	tooltip.set_text(text)
	if highlight_target != "":
		var target = get_tree().get_first_node_in_group(highlight_target)
		if target:
			tooltip.point_to(target)
	add_child(tooltip)

func next_step():
	current_step += 1
	show_current_step()

func skip_tutorial():
	finish_tutorial()

func finish_tutorial():
	tutorials_completed[current_tutorial.level] = true
	emit_signal("tutorial_finished", current_tutorial.level)
	current_tutorial = {}
