extends Node2D

# Outbox Pattern Level Implementation
# Manual implementation following project conventions
# No AI / Copilot usage

extends Node2D

var outbox_buffer = []
var events_delivered = 0
var level_complete = false

func _ready():
    $Outbox.visible = true
    $Source.connect("event_spawned", _on_event_spawned)
    $Outbox.connect("event_entered", _on_event_entered_outbox)
    $Outbox.connect("event_exited", _on_event_exited_outbox)
    $Sink.connect("event_received", _on_event_received)

func _on_event_spawned(event):
    event.passed_through_outbox = false

func _on_event_entered_outbox(event):
    outbox_buffer.append(event)
    event.passed_through_outbox = true

func _on_event_exited_outbox(event):
    outbox_buffer.erase(event)

func _on_event_received(event):
    if level_complete:
        return
    
    if event.passed_through_outbox:
        events_delivered += 1
        check_level_complete()
    else:
        # ❌ Direct delivery without Outbox
        level_failure("Invalid Pattern! Events must pass through Outbox buffer first.")

func check_level_complete():
    if events_delivered >= 3:
        level_complete = true
        # ✅ Correct Outbox Pattern usage
        level_success()

func level_success():
    AudioManager.play_level_clear()
    var message = preload("res://Scenes/message_display.tscn").instantiate()
    add_child(message)
    message.z_index = 999
    message.show_message("Success! Outbox Pattern executed correctly.")
    await message.show_message_for_duration(2.5)
    
    Level.levelind = 4
    ConveyerController.initialise()
    get_tree().change_scene_to_file("res://Scenes/multiSink.tscn")

func level_failure(reason):
    AudioManager.play_level_fail()
    var message = preload("res://Scenes/message_display.tscn").instantiate()
    add_child(message)
    message.z_index = 999
    message.show_message(reason)
    await message.show_message_for_duration(2.5)
    get_tree().reload_current_scene()