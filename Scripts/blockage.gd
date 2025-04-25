extends Node2D


func _on_blockage_left_area_entered(area: Area2D) -> void:
		if area.is_in_group("Blockage"):
			print("Blockage Detected")
			$"Blockage Left/BlockageLeft".on_blockage()
			$"Blockage Right/BlockageRight".on_blockage()
			$"dls_initial/DlqInitial".on_blockage()
			$"dls_final/DlqFinal".on_blockage()
