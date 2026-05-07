extends Draggable

class_name SlotObject

const LERP_SPEED: float = 0.2
const SNAP_SPEED: float = 0.1

var origin: Vector2
var isSlotted: bool = false
var slot: Slot 
var holdingLock: bool = false

func _ready() -> void:
	origin = global_position

func _process(delta: float) -> void:
	if not isSlotted:
		global_position = lerp(global_position, origin, LERP_SPEED)
	
	if isHolding:
		holdingLock = false
		if is_instance_valid(slot) and slot.slottedObject == self:
			slot.takeObject()
		
		slot = getNearestSlot()
		isSlotted = is_instance_valid(slot)
		
	elif not holdingLock and is_instance_valid(slot):
		holdingLock = true
		slot.receiveObject(self)
		customAnimator.snapTo(slot.global_position, SNAP_SPEED)
		
	
	
	customAnimator.titter(isHolding and isSlotted)
	
	# this makes the object follow the cursor if it is pressed
	# as it is the currently the last call in the frame, it overrides all global pos changes
	super._process(delta)

func getNearestSlot() -> Slot:
	var nearest: Slot = null
	var nearestDist: float = INF
	for a in area.get_overlapping_areas():
		var d: float = global_position.distance_to(a.global_position)
		if d < nearestDist:
			nearestDist = d
			nearest = a.get_parent()
	return nearest
