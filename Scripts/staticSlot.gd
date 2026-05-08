extends Node2D

class_name StaticSlot

@export var answer: String

var correctionDuration: float = 2.0
var slottedObject: ControlBlock

func setSlottedObject(object: ControlBlock):
	slottedObject = object

func setType(type: int):
	$Area2D.set_collision_layer_value(type, true)

func swapObjectWithSlot(other: StaticSlot):
	var otherObject: ControlBlock = other.slottedObject
	otherObject.slot = self
	slottedObject.slot = other
	other.slottedObject = slottedObject
	slottedObject = otherObject

func isCorrect() -> bool:
	return slottedObject.objectName == answer

var correctionTimer: float = 0
func _process(delta: float) -> void:
	correctionTimer = move_toward(correctionTimer, 0, delta)
	
	if correctionTimer > 0:
		if isCorrect():
			slottedObject.targetColor = Color.LIME_GREEN
		else:
			slottedObject.customAnimator.triggerShake()
			slottedObject.targetColor = Color.INDIAN_RED
	else:
		if is_instance_valid(slottedObject):
			slottedObject.targetColor = Color.WHITE
		

func check():
	correctionTimer = correctionDuration
	return isCorrect()
