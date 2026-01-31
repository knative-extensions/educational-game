# DataRef Pattern Level script
# Works with the existing game architecture

extends Node2D

@onready var storage_node = $StorageNode
@onready var large_box = $LargeBox
@onready var reference_box = $ReferenceBox

var storage_clicked: bool = false
var storage_was_used: bool = false  # Preserve across initialise() calls


func _ready() -> void:
	# Standard initialization like other levels
	ConveyerController.can_send = false
	
	# Make sure large box is visible at start
	if large_box != null:
		large_box.visible = true
		print("Large box initialized")
	
	# Hide reference box at start
	if reference_box != null:
		reference_box.visible = false
		print("Reference box hidden")
	
	print("=== DataRef level loaded ===")
	print("Step 1: Click STORAGE (left side)")


func _process(_delta: float) -> void:
	pass


# When storage area is clicked
func _on_storage_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if not storage_clicked:
			_store_payload()


func _store_payload() -> void:
	storage_clicked = true
	storage_was_used = true  # Remember this for later
	Level.storageUsed = true
	print(">>> STORAGE CLICKED <<<")
	
	# Hide the large box
	if large_box != null:
		large_box.visible = false
		print("Large box hidden - payload stored")
	
	# Show the reference box
	if reference_box != null:
		reference_box.visible = true
		# Add to conveyor events so player can select it
		if not ConveyerController.events.has(reference_box):
			ConveyerController.events.append(reference_box)
		print("Step 2: Reference box created! Click it to select")


# When reference box is clicked
func _on_reference_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if reference_box != null and reference_box.visible:
			ConveyerController.selected = reference_box
			print(">>> REFERENCE SELECTED <<<")
			print("Step 3: Now click the SINK to create route!")


# When something enters sink area
func _on_sink_area_entered(area: Area2D) -> void:
	print(">>> Something entered sink area <<<")
	if area.is_in_group("ReferenceBox") or area.is_in_group("Box"):
		print(">>> REFERENCE DELIVERED TO SINK <<<")
		# Restore storage state (in case Level.initialise() reset it)
		if storage_was_used:
			Level.storageUsed = true
		Level.sinkUsed = true
		Level.sinkBoxMatchPresent = true
		print("Level.storageUsed = ", Level.storageUsed)
		print("Level.sinkBoxMatchPresent = ", Level.sinkBoxMatchPresent)
