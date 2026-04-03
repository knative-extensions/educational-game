extends Control

var level_descriptions = [
	"Level 1: Basic Event Flow\n\nEvents flow directly from Source to Sink.\n\nThis is the simplest event driven pattern.",
	"Level 2: Filter Pattern\n\nUse filters to route only matching events.\n\nThis is how triggers work in Knative.",
	"Level 3: Multi Sink Pattern\n\nOne source can send events to multiple destinations.\n\nThis demonstrates fanout pattern.",
	"Level 4: DLQ Pattern\n\nFailed events go to Dead Letter Queue.\n\nThis is how failed messages are handled reliably.",
	"Level 5: Outbox Pattern\n\nEvents are buffered before delivery.\n\nThis ensures reliable at-least-once delivery."
]

func _ready():
	$Description.text = level_descriptions[Level.levelind]

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/" + Level.levels[Level.levelind] + ".tscn")