extends Sprite2D

class_name ControlBlock

@onready var customAnimator: CustomAnimator = $CustomAnimator
@onready var draggableControl: DraggableControl = $DraggableControl
@onready var sprite: NinePatchRect = $ControlBlock

@onready var area: Area2D = $Area2D

@export var objectName: String
@export var slot: StaticSlot
@export var type: int = 1
var targetSlot: StaticSlot
var targetColor: Color = Color.WHITE

func _ready() -> void:
	slot.setSlottedObject(self)
	area.set_collision_mask_value(type, true)
	slot.setType(type)
	global_position = slot.global_position
	

func _process(delta: float) -> void:
	sprite.self_modulate = lerp(sprite.self_modulate, targetColor, 0.3)
	
	if draggableControl.isHolding:
		customAnimator.setScale(0.6)
		targetSlot = getNearestSlot()
		modulate = Color.LIGHT_GRAY
	else:
		if draggableControl.hasJustLetGo():
			customAnimator.setScale(1)
			targetSlot.swapObjectWithSlot(slot)
			modulate = Color.WHITE
		global_position = lerp(global_position, slot.global_position, 0.2)

func getNearestSlot() -> StaticSlot:
	var nearest: StaticSlot = slot
	var nearestDist: float = INF
	for a in area.get_overlapping_areas():
		var d: float = global_position.distance_to(a.global_position)
		if d < nearestDist:
			nearestDist = d
			nearest = a.get_parent()
	return nearest
