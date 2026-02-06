extends CanvasLayer

# ToastManager - Global autoload for showing toast notifications
# Usage: ToastManager.show("Message") or ToastManager.success("Yay!")

const TOAST_SCENE = preload("res://Scenes/toast.tscn")

# Toast colors
const COLOR_DEFAULT = Color(0.2, 0.2, 0.2, 0.9)
const COLOR_SUCCESS = Color(0.18, 0.55, 0.34, 0.95)  
const COLOR_ERROR = Color(0.7, 0.2, 0.2, 0.95)       
const COLOR_INFO = Color(0.2, 0.4, 0.7, 0.95)       
const COLOR_WARNING = Color(0.8, 0.6, 0.2, 0.95)     

# Toast positioning
var toast_margin: int = 20
var toast_spacing: int = 10
var active_toasts: Array = []

func _ready() -> void:
	# Set layer to be on top of everything
	layer = 100

# Show a default toast
func toast(message: String, duration: float = 2.0) -> void:
	_create_toast(message, duration, COLOR_DEFAULT)

# Show a success toast (green)
func success(message: String, duration: float = 2.0) -> void:
	_create_toast(message, duration, COLOR_SUCCESS)

# Show an error toast (red)
func error(message: String, duration: float = 2.5) -> void:
	_create_toast(message, duration, COLOR_ERROR)

# Show an info toast (blue)
func info(message: String, duration: float = 2.0) -> void:
	_create_toast(message, duration, COLOR_INFO)

# Show a warning toast (orange)
func warning(message: String, duration: float = 2.0) -> void:
	_create_toast(message, duration, COLOR_WARNING)

func _create_toast(message: String, duration: float, color: Color) -> void:
	var toast = TOAST_SCENE.instantiate()
	add_child(toast)
	
	# Setup toast content
	toast.setup(message, duration, color)
	
	# Position at bottom center of screen
	var viewport_size = get_viewport().get_visible_rect().size
	var toast_width = 300
	var toast_height = 60
	
	# Calculate vertical position based on active toasts
	var y_offset = toast_margin + (active_toasts.size() * (toast_height + toast_spacing))
	
	toast.position = Vector2(
		(viewport_size.x - toast_width) / 2,
		viewport_size.y - toast_height - y_offset
	)
	
	# Track active toast
	active_toasts.append(toast)
	toast.tree_exited.connect(_on_toast_removed.bind(toast))
	
	# Show with animation
	toast.show_toast()

func _on_toast_removed(toast: Control) -> void:
	active_toasts.erase(toast)
	# Reposition remaining toasts
	_reposition_toasts()

func _reposition_toasts() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var toast_height = 60
	
	for i in active_toasts.size():
		var toast = active_toasts[i]
		if is_instance_valid(toast):
			var y_offset = toast_margin + (i * (toast_height + toast_spacing))
			var target_y = viewport_size.y - toast_height - y_offset
			
			# Animate repositioning
			var tween = create_tween()
			tween.tween_property(toast, "position:y", target_y, 0.2).set_ease(Tween.EASE_OUT)
