extends Activity

@export var requiredSlots: Array[ObjectSlot]

func _ready() -> void:
	SignalBus.objectSlotted.connect(onObjectSlotted)

func onObjectSlotted():
	var allCorrect: bool = true
	for slot in requiredSlots:
		if not is_instance_valid(slot.object):
			allCorrect = false
			break
		if not slot.isCorrect():
			allCorrect = false
			break
	
	if allCorrect:
		finish()
	#else:
		#SignalBus.warn.emit("Incorrect Placement!")
