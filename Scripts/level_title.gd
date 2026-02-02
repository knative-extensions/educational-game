extends CanvasLayer

var _title_label: Label

func _ready():
	name = "LevelTitleOverlay"
	
	_title_label = Label.new()
	add_child(_title_label)
	
	_title_label.anchors_preset = Control.PRESET_TOP_LEFT
	_title_label.position = Vector2(20, 80)
	_title_label.grow_horizontal = Control.GROW_DIRECTION_END
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	var settings = LabelSettings.new()
	settings.font_size = 22
	
	settings.outline_size = 5
	settings.outline_color = Color(0.05, 0.05, 0.05, 1)
	
	settings.shadow_size = 4
	settings.shadow_color = Color(0, 0, 0, 0.4)
	settings.shadow_offset = Vector2(2, 2)
	
	settings.font_color = Color(1, 0.9, 0.6, 1)
	
	_title_label.label_settings = settings

func update_text(text: String):
	_title_label.text = text
	_title_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_title_label.position = Vector2(20, 80)

func set_visible_state(is_visible: bool):
	visible = is_visible