extends Activity

@onready var customAnimator: CustomAnimator = $CustomAnimator
var blockSlots: Array[StaticSlot]

var initialPos: Vector2

func _ready() -> void:
	SignalBus.answerSubmitted.connect(check)
	SignalBus.startEvent.connect(start)
	initialPos = self.global_position
	
	for column in get_children():
		for grandchild in column.get_children():
			if is_instance_of(grandchild, StaticSlot):
				blockSlots.append(grandchild)
	
func start(id: int):
	if id != eventID:
		return
	active = true
	customAnimator.floatIn(initialPos, 0.5)

func check():
	var isWrong: bool = false
	for slot: StaticSlot in blockSlots:
		if not slot.check():
			isWrong = true
	if isWrong: return
	active = false
	await customAnimator.floatOut(initialPos, 0.3)
	finish()
