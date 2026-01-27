extends Area2D

# Reference to the lightweight token (Claim Check) that will be sent.
@export var token_object: Node2D

# The target destination coordinate on the conveyor belt.
@export var destination: Vector2 = Vector2(900, 300)

func _ready() -> void:
	# Ensure the token is hidden initially to simulate that the reference
	# has not been generated yet.
	if token_object:
		token_object.visible = false

func _on_area_entered(area: Area2D) -> void:
	# Detect if the entering object is a "BigData" payload (Large Message).
	if area.is_in_group("BigData"):
		print("Warehouse: Large Payload intercepted. Offloading to storage")
		
		# Simulate data storage by removing the heavy payload from the scene.
		area.queue_free()
		
		# Generate and dispatch the Reference Token.
		_dispatch_claim_check()

func _dispatch_claim_check() -> void:
	if token_object:
		print("Warehouse: Claim Check Token generated. Dispatching to Event Bus.")
		
		# Activate the token and set its starting position to the Warehouse center.
		token_object.visible = true
		token_object.global_position = global_position 
		
		# Create tween
		var tween = get_tree().create_tween()
		
		# TRANS_QUAD + EASE_OUT makes it start fast and slow down smoothly at the end.
		# Reduced time to 2.5 seconds for snappier feel.
		tween.tween_property(token_object, "global_position", destination, 2.5)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
		
		# Optional callback
		tween.tween_callback(func(): print("Delivery Complete."))
