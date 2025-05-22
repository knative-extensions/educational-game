extends Node2D
func start1():
	var dest_size=ConveyerController.destination.size()
	var Start=[dest_size*0,dest_size*1,dest_size*2]
	var extra=dest_size-1
	print(extra)
	
	var Boxes = [$BoxB,$BoxR,$BoxG]
	for i in Boxes.size():
		print("i",i)
		var packed = PackedScene.new()
		packed.pack(Boxes[i])
		for m in extra:
			print("m",m)
			var clone = packed.instantiate()
			add_child(clone)
			var box=ConveyerController.events.pop_back()
			print(box)
			ConveyerController.events.insert(Start[i],box)
	print("No of events: ",ConveyerController.events.size())
	ConveyerController.can_send=true


func _on_button_pressed() -> void:
	start1()
