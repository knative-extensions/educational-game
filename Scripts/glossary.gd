extends Control

var terms = {
	"Event": "The boxes that move across the screen. Represents real Cloud Events in Knative.",
	"Source": "Where events originate from. Produces events for the system.",
	"Sink": "Destination where events are delivered. Represents a microservice.",
	"Filter": "The funnel shaped object. Routes events that match specific patterns.",
	"Broker": "Central hub that receives events and forwards them to subscribers.",
	"DLQ": "Dead Letter Queue. Stores events that failed delivery.",
	"Outbox": "Buffer pattern that ensures reliable event delivery.",
	"Transformer": "Modifies events before they are delivered to sink."
}

func _ready():
	visible = false

func _on_help_button_pressed():
	visible = !visible

func _on_close_button_pressed():
	visible = false