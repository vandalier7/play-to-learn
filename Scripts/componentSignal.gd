extends EventSignal

class_name ComponentSignal

@export var componentName: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signalName = "actuated"
	SignalBus.connect(signalName, actuate)


func actuate(n: String):
	if n == componentName:
		fireSignal()
