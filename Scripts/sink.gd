extends Sprite2D

@export var expectedType: String
@export var available: bool = true

var blink_timer: float = 0.0
var blink_interval: float = 0.5
var indicator_light: ColorRect = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	indicator_light = get_node_or_null("IndicatorLight")
	if indicator_light == null:
		push_warning("IndicatorLight not found in sink scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if indicator_light != null:
		if available:
			blink_timer += delta
			if blink_timer >= blink_interval:
				blink_timer = 0.0
				indicator_light.visible = !indicator_light.visible
		else:
			indicator_light.visible = false
