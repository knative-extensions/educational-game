extends Sprite2D

@export var expectedType: String

@export var available: bool = true:
	set(value):
		available = value
		if indicator_light:
			indicator_light.visible = value

@onready var indicator_light: Control = $IndicatorLight

func _ready() -> void:
	if indicator_light:
		indicator_light.visible = available

func _process(_delta: float) -> void:
	if available and indicator_light:
		var time = Time.get_ticks_msec() / 200.0
		indicator_light.modulate.a = 0.6 + (sin(time) * 0.4)