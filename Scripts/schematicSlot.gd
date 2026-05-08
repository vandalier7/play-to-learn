extends Slot

class_name SchematicSlot

const displayDuration: float = 3.0

@export var matchedObject: String

@onready var correction: Sprite2D = $Correction

var targetColor: Color = Color.TRANSPARENT
var displayTime: float = 0
var correct: bool = false

func _ready() -> void:
	SignalBus.answerSubmitted.connect(check)

func check():
	displayTime = displayDuration
	if not is_instance_valid(slottedObject):
		targetColor = Color.RED
		return
	
	assert(is_instance_of(slottedObject, SchematicObject))
	
	var object: SchematicObject = slottedObject
	if object.objectName == matchedObject:
		targetColor = Color.GREEN
		correct = true
	else:
		correct = false
		targetColor = Color.RED
		customAnimator.triggerShake()
		await get_tree().create_timer(0.2).timeout
		_releaseObject()
	
	

func _process(delta: float) -> void:
	displayTime = move_toward(displayTime, 0.0, delta)
	
	if displayTime == 0:
		targetColor = Color.TRANSPARENT
	
	correction.modulate = lerp(correction.modulate, targetColor, 0.2)
	
	super._process(delta)
