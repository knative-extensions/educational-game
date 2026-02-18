extends Control

@onready var search_box = $CanvasLayer/Panel/MarginContainer/VBoxContainer/SearchBox
@onready var results_list = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ScrollContainer/ResultsList
@onready var concept_panel = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConceptPanel
@onready var concept_name = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConceptPanel/ConceptName
@onready var definition = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConceptPanel/Definition
@onready var game_example = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConceptPanel/GameExample
@onready var knative_example = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConceptPanel/KnativeExample
@onready var docs_button = $CanvasLayer/Panel/MarginContainer/VBoxContainer/ConceptPanel/DocsButton
@onready var close_button = $CanvasLayer/Panel/MarginContainer/VBoxContainer/CloseButton

var concepts = {
	"source": {
		"name": "Event Source",
		"definition": "A source generates events and sends them to a broker",
		"game_example": "The event boxes at the start of each level",
		"knative_example": "PingSource, ApiServerSource, KafkaSource",
		"docs": "https://knative.dev/docs/eventing/sources/"
	},
	"broker": {
		"name": "Broker",
		"definition": "A broker receives events from sources and delivers them to sinks via triggers",
		"game_example": "The invisible routing system that moves events in the game",
		"knative_example": "MTChannelBasedBroker, RabbitMQBroker",
		"docs": "https://knative.dev/docs/eventing/brokers/"
	},
	"trigger": {
		"name": "Trigger",
		"definition": "A trigger filters events and routes matching ones to a specific sink",
		"game_example": "The connection you create from event to sink",
		"knative_example": "Trigger with CloudEvents attribute filters",
		"docs": "https://knative.dev/docs/eventing/triggers/"
	},
	"filter": {
		"name": "Filter",
		"definition": "Rules that determine which events match a trigger",
		"game_example": "The colored filters you drag onto the conveyor",
		"knative_example": "CloudEvents attribute filters (type, source, etc.)",
		"docs": "https://knative.dev/docs/eventing/triggers/#trigger-filtering"
	},
	"sink": {
		"name": "Sink",
		"definition": "A sink receives and processes events",
		"game_example": "The colored boxes where events are delivered",
		"knative_example": "Knative Service, Channel, URI endpoint",
		"docs": "https://knative.dev/docs/eventing/sinks/"
	},
	"dlq": {
		"name": "Dead Letter Queue",
		"definition": "A special sink that catches events that fail to process",
		"game_example": "The DLS that catches blocked events in Level 4",
		"knative_example": "DeadLetterSink in delivery spec",
		"docs": "https://knative.dev/docs/eventing/event-delivery/"
	},
	"cloudevents": {
		"name": "CloudEvents",
		"definition": "A standard format for describing events",
		"game_example": "The event boxes with different colors (types)",
		"knative_example": "CloudEvents spec with type, source, id, etc.",
		"docs": "https://cloudevents.io/"
	},
	"channel": {
		"name": "Channel",
		"definition": "A messaging channel that can be used as a sink or source",
		"game_example": "Not directly shown in current levels",
		"knative_example": "InMemoryChannel, KafkaChannel",
		"docs": "https://knative.dev/docs/eventing/channels/"
	},
	"subscription": {
		"name": "Subscription",
		"definition": "Routes events from a channel to a sink",
		"game_example": "Similar to the trigger concept in the game",
		"knative_example": "Subscription connecting Channel to Sink",
		"docs": "https://knative.dev/docs/eventing/channels/subscriptions/"
	},
	"retry": {
		"name": "Retry Policy",
		"definition": "Configuration for retrying failed event deliveries",
		"game_example": "Related to DLQ pattern in Level 4",
		"knative_example": "Retry count and backoff delay in delivery spec",
		"docs": "https://knative.dev/docs/eventing/event-delivery/"
	}
}

func _ready():
	add_to_group("Glossary")
	search_box.text_changed.connect(_on_search_changed)
	close_button.pressed.connect(_on_close_pressed)
	docs_button.pressed.connect(_on_docs_pressed)
	concept_panel.visible = false
	populate_all_concepts()

func populate_all_concepts():
	results_list.clear()
	for key in concepts:
		results_list.add_item(concepts[key].name)

func _on_search_changed(query: String):
	if query == "":
		populate_all_concepts()
		return
	
	results_list.clear()
	for key in concepts:
		if key.contains(query.to_lower()) or \
		   concepts[key].name.to_lower().contains(query.to_lower()):
			results_list.add_item(concepts[key].name)

func _on_results_list_item_selected(index: int):
	var item_text = results_list.get_item_text(index)
	for key in concepts:
		if concepts[key].name == item_text:
			show_concept(key)
			break

func show_concept(concept_id: String):
	var concept = concepts.get(concept_id)
	if concept:
		concept_name.text = concept.name
		definition.text = concept.definition
		game_example.text = "🎮 In game: " + concept.game_example
		knative_example.text = "📦 In Knative: " + concept.knative_example
		docs_button.set_meta("url", concept.docs)
		concept_panel.visible = true

func _on_close_pressed():
	$CanvasLayer.visible = false

func _on_docs_pressed():
	var url = docs_button.get_meta("url")
	OS.shell_open(url)

func open_to_term(term: String):
	$CanvasLayer.visible = true
	if concepts.has(term):
		show_concept(term)

func open():
	$CanvasLayer.visible = true
