extends Node2D

class_name Slot

@onready var customAnimator: CustomAnimator = $CustomAnimator

var objectFitted: bool = false
var slottedObject: SlotObject

func receiveObject(object: SlotObject):
	if is_instance_valid(slottedObject):
		_releaseObject()
		objectFitLock = false
	slottedObject = object

func takeObject():
	slottedObject = null
	get_parent().ensureSlotsFilled()

func _releaseObject():
	if is_instance_valid(slottedObject):
		slottedObject.isSlotted = false
	slottedObject = null
	get_parent().ensureSlotsFilled()
	

func isObjectFitted() -> bool:
	if not is_instance_valid(slottedObject):
		return false
	return slottedObject.global_position.distance_to(global_position) < 40

func hasObject() -> bool:
	return is_instance_valid(slottedObject)

var objectFitLock: bool = false
func _process(delta: float) -> void:
	if isObjectFitted():
		if not objectFitLock:
			customAnimator.triggerShake()
			get_parent().ensureSlotsFilled()
			objectFitLock = true
	else:
		objectFitLock = false
