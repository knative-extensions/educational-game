extends Control

func show_message(text):
	print("Message displayed")
	$Label.text=text
	
func show_message_for_duration(duration: float) -> void:
	var timer := Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
