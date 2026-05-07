extends Node

class_name EventSignal

@export var signalName: String
var eventID: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(SignalBus.has_signal(signalName))
	SignalBus.connect(signalName, fireSignal)

func prepare(id: int):
	eventID = id

func fireSignal():
	SignalBus.eventEnded.emit(eventID)
