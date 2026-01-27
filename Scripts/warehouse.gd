extends Area2D


# Reference to the lightweight visual token to be generated.
@export var token_object: Node2D

# Reference to the destination Knative Sink where the token will be delivered.
# We use a Node2D reference instead of coordinates for dynamic positioning.
@export var target_sink: Node2D

func _ready() -> void:
	# Ensure the token is hidden initially. It should only appear
	# after the warehouse successfully stores the payload.
	if token_object:
		token_object.visible = false

func _on_area_entered(area: Area2D) -> void:
	# Detect if the entering object is a "BigData" payload.
	if area.is_in_group("BigData"):
		print("Warehouse: Large Payload intercepted. Offloading to external storage")
		
		# Simulate data storage by removing the heavy payload from the scene.
		area.queue_free()
		
		# Dispatch the Reference Token to the broker/sink.
		_dispatch_claim_check()

func _dispatch_claim_check() -> void:
	# Verify that both the token and the destination sink are assigned to prevent crashes.
	if token_object and target_sink:
		print("Dispatching Claim Check Token to Knative Sink")
		
		# Activate the token and set its starting position to the Warehouse location.
		token_object.visible = true
		token_object.global_position = global_position 
		
		# Create a tween to animate the token traveling across the system.
		var tween = get_tree().create_tween()
		
		# Animate movement to the exact position of the Target Sink component.
		# Using QUAD/EASE_OUT for a smooth entry effect.
		tween.tween_property(token_object, "global_position", target_sink.global_position, 2.5)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)
			
		# Callback to log successful delivery.
		tween.tween_callback(func(): print("Delivery Complete: Token consumed by Sink."))
