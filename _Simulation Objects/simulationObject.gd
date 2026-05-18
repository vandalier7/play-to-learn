extends Node2D
class_name SimulationObject

@onready var customAnimator: CustomAnimator = $CustomAnimator
@export var printLogs: bool = false
@export var objectName: String
@export var inputPorts: Array[SchematicNode]
@export var outputPorts: Array[SchematicNode]

func _ready() -> void:
	customAnimator.floatIn(global_position, 0.25)
	add_to_group("Simulation Objects")
	
	for port in outputPorts:
		port.setInputOutput(true)
	

func disconnectAll():
	for port in inputPorts:
		port.disconnectWire()
	for port in outputPorts:
		port.disconnectWire()

## Override in subclasses. Reads inputs, computes, writes to outputs.
func simulate() -> void:
	var pressure: float = getInputPressure()
	setOutputPressure(pressure)
	if printLogs:
		print(objectName, ": ", pressure)

func getInputPressure() -> float:
	var total: float = 0.0
	for port in inputPorts:
		if is_instance_valid(port.line):
			total += port.intake()
	return total

func setOutputPressure(pressure: float) -> void:
	
	for port in outputPorts:
		if is_instance_valid(port.line):
			if General.phase not in [General.Phase.Simulation]:
				port.release(0)
				continue
			port.release(pressure)
