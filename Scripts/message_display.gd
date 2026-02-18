extends Control

func show_message(text):
	print("Message displayed")
	$CenterContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Label.text = text
	
func show_message_for_duration(duration: float) -> void:
	var timer := Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func show_failure_with_lesson(reason: String, hint: String, lesson: String):
	var full_message = "❌ Level Failed\n\n"
	full_message += "Why: " + reason + "\n\n"
	full_message += "💡 Hint: " + hint + "\n\n"
	full_message += "🎓 Knative Concept:\n" + lesson
	$CenterContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Label.text = full_message
