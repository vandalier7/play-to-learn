## Emits a SignalBus signal when it is its turn. Finishes automatically.
extends Node

class_name Action

@export var signalName: String
@export var preDelay: float = 0
@export var postDelay: float = 0
var eventID: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#assert(SignalBus.has_signal(signalName))
	SignalBus.startEvent.connect(start)
	

func prepare(id: int):
	eventID = id

func start(id: int):
	if id != eventID:
		return
	#await get_tree().create_timer(preDelay).timeout
	SignalBus.emit_signal(signalName)
	#await get_tree().create_timer(postDelay).timeout
	fireSignal()

func fireSignal():
	SignalBus.eventEnded.emit(eventID)
