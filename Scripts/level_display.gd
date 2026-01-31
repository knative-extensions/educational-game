extends CanvasLayer

@onready var label = $PanelContainer/Label

func update_display(current_level: int, total_levels: int):
	label.text = "Level Progress: " + str(current_level) + " / " + str(total_levels)