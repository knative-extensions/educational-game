extends Control

@onready var label = $Panel/MarginContainer/VBoxContainer/Label
@onready var next_button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/NextButton
@onready var skip_button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/SkipButton

func set_text(text: String):
	label.text = text

func point_to(target: Node2D):
	# Position tooltip near target
	global_position = target.global_position + Vector2(50, -100)

func _on_next_button_pressed():
	TutorialManager.next_step()
	queue_free()

func _on_skip_button_pressed():
	TutorialManager.skip_tutorial()
	queue_free()
