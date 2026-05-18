extends Node2D
class_name ElectricObject

@onready var customAnimator: CustomAnimator = $CustomAnimator
@export var printLogs: bool = false
@export var objectName: String
@export var isOn: bool = true
@export var inputPorts: Array[SchematicNode]
@export var outputPorts: Array[SchematicNode]
@export var isSource: bool = false
var circuit: Array

func _ready() -> void:
	customAnimator.floatIn(global_position, 0.25)
	add_to_group("Electric Objects")
	
	for port in outputPorts:
		port.setInputOutput(true)
		port.isElectric = true
	
	for port in inputPorts:
		port.isElectric = true
	

func disconnectAll():
	for port in inputPorts:
		port.disconnectWire()
	for port in outputPorts:
		port.disconnectWire()
