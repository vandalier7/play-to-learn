extends Node2D

class_name ObjectSlot

@export var requiredObject: String

@onready var customAnimator: CustomAnimator = $Sprite2D/CustomAnimator
var object: SimulationObject

func titter():
	#if is_instance_valid(object):
		#customAnimator.shakeSpeed = 1.5
	customAnimator.triggerShake()

func placeObject(obj: SimulationObject):
	if is_instance_valid(object):
		object.disconnectAll()
		remove_child(object)
		object.queue_free()
	object = obj
	
	if isCorrect():
		SignalBus.tryTriggerEvent(self)
	else:
		SignalBus.warn.emit("Incorrect Placement!")
	add_child(obj)
	SignalBus.objectSlotted.emit()

func isCorrect():
	return object.objectName == requiredObject
