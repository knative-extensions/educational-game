extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/boxClick.tscn")


func _on_play_2_pressed() -> void:
	get_tree().quit()
