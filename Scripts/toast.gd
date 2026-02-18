extends Control

# Toast notification - individual toast instance
var duration: float = 2.0

func _ready() -> void:
	# Start invisible for fade-in
	modulate.a = 0.0

func setup(message: String, toast_duration: float = 2.0, color: Color = Color(0.2, 0.2, 0.2, 0.9)) -> void:
	duration = toast_duration
	$Panel/Label.text = message
	
	# Set panel color based on toast type
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 15
	style.content_margin_right = 15
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	$Panel.add_theme_stylebox_override("panel", style)

func show_toast() -> void:
	# Fade in
	var tween_in = create_tween()
	tween_in.tween_property(self, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
	await tween_in.finished
	
	# Wait for duration
	await get_tree().create_timer(duration).timeout
	
	# Fade out
	var tween_out = create_tween()
	tween_out.tween_property(self, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
	await tween_out.finished
	
	# Remove self
	queue_free()
