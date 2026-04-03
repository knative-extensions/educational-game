extends Node2D

var tween: Tween

func show(message: String, duration: float = 2.0):
	self.visible = true
	$Label.text = message
	
	# Animate in
	self.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_interval(duration)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func(): self.visible = false)