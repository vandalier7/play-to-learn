extends Slot

const displayDuration: float = 2.0

@export var matchedObject: String

@onready var correction: Sprite2D = $Correction

var targetColor: Color = Color.TRANSPARENT
var displayTime: float = 0

func check():
	displayTime = displayDuration
	if not is_instance_valid(slottedObject):
		targetColor = Color.RED
		return
	
	assert(is_instance_of(slottedObject, SchematicObject))
	
	var object: SchematicObject = slottedObject
	if object.objectName == matchedObject:
		targetColor = Color.GREEN
	else:
		targetColor = Color.RED
	
	

func _process(delta: float) -> void:
	displayTime = move_toward(displayTime, 0.0, delta)
	
	if displayTime == 0:
		targetColor = Color.TRANSPARENT
	
	if Input.is_action_just_pressed("ui_accept"):
		check()
	
	correction.modulate = lerp(correction.modulate, targetColor, 0.2)
	
	super._process(delta)
