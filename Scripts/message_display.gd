extends CanvasLayer

signal dismissed

@onready var label = %Label
@onready var quack = %QuackTexture
@onready var blur = %Blur
@onready var root = %Root

var is_hovering = false

@onready var continue_button = %ContinueButton

func _ready():
	print("Popup ready - connecting button signals")
	# Initial transparency for fade-in
	root.modulate.a = 0.0
	# Set blur to 0 initially
	blur.material.set_shader_parameter("blur_amount", 0.0)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(root, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(blur.material, "shader_parameter/blur_amount", 2.5, 0.4)
	
	# Setup juicy button animations
	await get_tree().process_frame
	if continue_button:
		continue_button.pivot_offset = continue_button.size / 2 # Ensure centered scaling
		
		continue_button.mouse_entered.connect(_on_button_hover)
		continue_button.mouse_exited.connect(_on_button_unhover)
		continue_button.button_down.connect(_on_button_down)
		continue_button.button_up.connect(_on_button_up)

func _on_button_hover():
	if not is_instance_valid(continue_button): return
	is_hovering = true
	continue_button.pivot_offset = continue_button.size / 2
	var tween = create_tween()
	tween.tween_property(continue_button, "scale", Vector2(1.08, 1.08), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(continue_button, "self_modulate", Color(1.3, 1.3, 1.3), 0.1) # Brighten

func _on_button_unhover():
	if not is_instance_valid(continue_button): return
	is_hovering = false
	continue_button.pivot_offset = continue_button.size / 2
	var tween = create_tween()
	tween.tween_property(continue_button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(continue_button, "self_modulate", Color(1, 1, 1), 0.1)

func _on_button_down():
	if not is_instance_valid(continue_button): return
	print("Button DOWN")
	continue_button.pivot_offset = continue_button.size / 2
	var tween = create_tween()
	# Dramatic Shrink and Darken
	tween.tween_property(continue_button, "scale", Vector2(0.85, 0.85), 0.05).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(continue_button, "self_modulate", Color(0.5, 0.5, 0.5), 0.05) # Much darker

func _on_button_up():
	if not is_instance_valid(continue_button): return
	print("Button UP")
	continue_button.pivot_offset = continue_button.size / 2
	var tween = create_tween()
	# Bouncy Pop back out
	tween.tween_property(continue_button, "scale", Vector2(1.15, 1.15), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if is_hovering:
		tween.tween_property(continue_button, "scale", Vector2(1.08, 1.08), 0.05)
		tween.parallel().tween_property(continue_button, "self_modulate", Color(1.3, 1.3, 1.3), 0.05)
	else:
		tween.tween_property(continue_button, "scale", Vector2(1.0, 1.0), 0.05)
		tween.parallel().tween_property(continue_button, "self_modulate", Color(1, 1, 1), 0.05)

func show_message(text):
	print("Message displayed")
	if text == "Success":
		quack.visible = true
		label.text = "[center][b][color=#10a30b][font_size=56]Success![/font_size][/color][/b]\n\n[font_size=32]Level Completed Successfully[/font_size][/center]"
	else:
		quack.visible = false
		label.text = "[center]" + text + "[/center]"
	
func show_message_for_duration(_duration: float) -> void:
	# Ignore duration and wait for the dismissed signal
	await dismissed

func show_failure_with_lesson(reason: String, hint: String, lesson: String):
	quack.visible = false # Keep focus on the lesson
	var full_message = "[center][b][color=#e63946][font_size=32]Level Failed[/font_size][/color][/b][/center]\n\n"
	full_message += "❌ [font_size=24][b]Why:[/b][/font_size]\n[font_size=20]" + reason + "[/font_size]\n\n"
	full_message += "💡 [font_size=24][b]Hint:[/b][/font_size]\n[font_size=20]" + hint + "[/font_size]\n\n"
	full_message += "🎓 [font_size=24][b]Knative Concept:[/b][/font_size]\n[font_size=20]" + lesson + "[/font_size]"
	label.text = full_message

func _on_continue_button_pressed():
	print("Continue button clicked!")
	# Small delay to let the 'up' animation show
	await get_tree().create_timer(0.1).timeout
	
	# Emit signal so level controller knows we're done
	dismissed.emit()
	
	# Fade out everything
	var tween = create_tween().set_parallel(true)
	tween.tween_property(root, "modulate:a", 0.0, 0.3)
	tween.tween_property(blur.material, "shader_parameter/blur_amount", 0.0, 0.3)
	await tween.finished
	queue_free()
