extends Control

func show_message(text):
	print("Message displayed")
	$Label.text = text
	
	# Animate popup slide in
	self.scale = Vector2(0.8, 0.8)
	self.modulate.a = 0.0
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.25)

func show_message_for_duration(duration: float) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_interval(duration)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.2)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
