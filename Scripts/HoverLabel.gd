extends Label

var hover_text: String = ""
var element_type: String = ""

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	mouse_filter = Control.MOUSE_FILTER_PASS

func set_hover_info(type: String, description: String):
	element_type = type
	hover_text = description

func _on_mouse_entered():
	if hover_text != "":
		var tooltip = create_tooltip()
		add_child(tooltip)

func _on_mouse_exited():
	for child in get_children():
		if child.name == "HoverTooltip":
			child.queue_free()

func create_tooltip() -> Control:
	var tooltip = Panel.new()
	tooltip.name = "HoverTooltip"
	tooltip.custom_minimum_size = Vector2(200, 60)
	tooltip.position = Vector2(0, -70)
	
	var label = Label.new()
	label.text = hover_text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	margin.add_child(label)
	
	tooltip.add_child(margin)
	return tooltip
