## Stalls the Director's Sequence until a specific signal from the SignalBus is fired.
extends Node

class_name EventSignal

@export var signalName: String
@export var delay: float
@export var args: int = 0
var eventID: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if signalName == "": return
	assert(SignalBus.has_signal(signalName))
	if args == 0:
		SignalBus.connect(signalName, fireSignal)
	elif args == 1:
		SignalBus.connect(signalName, fireSignal2)
		

func prepare(id: int):
	eventID = id

func fireSignal():
	await get_tree().create_timer(delay).timeout
	SignalBus.eventEnded.emit(eventID)

func fireSignal2(a):
	await get_tree().create_timer(delay).timeout
	SignalBus.eventEnded.emit(eventID)

func fireSignal3(a, b):
	await get_tree().create_timer(delay).timeout
	SignalBus.eventEnded.emit(eventID)
