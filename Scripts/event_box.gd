extends Sprite2D

@export var boxType: String
@export var sending = false



func _ready() -> void:
	print("event ready")
	print("event is color", boxType)
	ConveyerController.events.append(self)
	var stylebox = $hoverlabel.get_theme_stylebox("normal")
	if boxType == 'Red':
		
		if stylebox is StyleBoxFlat:
			stylebox = stylebox.duplicate()
			stylebox.bg_color = Color(1.0, 0.424, 0.475)
			$hoverlabel.add_theme_stylebox_override("normal", stylebox)
			$hoverlabel.set_text("[center][b]EVENT R")
			
	elif boxType == "Blue":
		$hoverlabel.position.x += 300
		if stylebox is StyleBoxFlat:
			stylebox = stylebox.duplicate()
			stylebox.bg_color = Color(0.431, 0.565, 1.0)
			$hoverlabel.set_text("[center][b]EVENT B")
			$hoverlabel.add_theme_stylebox_override("normal", stylebox)
		
	elif boxType == "Green":
		$hoverlabel.position.x += 300
		$hoverlabel.position.y +=  100
		if stylebox is StyleBoxFlat:
			stylebox = stylebox.duplicate()
			stylebox.bg_color = Color(0.31, 0.553, 0.204)
			$hoverlabel.add_theme_stylebox_override("normal", stylebox)
			$hoverlabel.set_text("[center][b]EVENT G")
			

func _input_event(viewport, event, shape_idx) -> void:
	print(event)
	if event.is_pressed():
		self.on_click()
		
func on_click():
	print("hi")
	ConveyerController.selected = self
	AudioManager.play_click_start()
