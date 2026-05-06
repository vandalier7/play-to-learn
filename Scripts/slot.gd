extends Node2D

class_name Slot

const SHAKE_TIME: float = 0.2
const SHAKE_MAGNITUDE: float = 3.0
const SHAKE_SPEED: float = 6.0

var objectFitted: bool = false
var slottedObject: SlotObject
var shakeTimer: float = 0.0

func triggerShake() -> void:
	shakeTimer = SHAKE_TIME

func shakeProcess(delta: float) -> void:
	if shakeTimer > 0:
		shakeTimer = move_toward(shakeTimer, 0.0, delta)
		var progress: float = shakeTimer / SHAKE_TIME
		rotation_degrees = sin(Time.get_ticks_msec() * 0.01 * SHAKE_SPEED) * SHAKE_MAGNITUDE * progress
	else:
		rotation_degrees = lerp(rotation_degrees, 0.0, 0.2)

func receiveObject(object: SlotObject):
	if is_instance_valid(slottedObject):
		_releaseObject()
		objectFitLock = false
	slottedObject = object

func takeObject():
	slottedObject = null

func _releaseObject():
	if is_instance_valid(slottedObject):
		slottedObject.isSlotted = false
	slottedObject = null

func isObjectFitted() -> bool:
	if not is_instance_valid(slottedObject):
		return false
	return slottedObject.global_position.distance_to(global_position) < 40
	

var objectFitLock: bool = false
func _process(delta: float) -> void:
	shakeProcess(delta)
	
	if isObjectFitted():
		if not objectFitLock:
			triggerShake()
			objectFitLock = true
	else:
		objectFitLock = false
