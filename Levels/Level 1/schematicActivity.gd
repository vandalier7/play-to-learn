extends Activity

@export var slots: Array[SchematicSlot]

@onready var customAnimator: CustomAnimator = $CustomAnimator

var initialPos: Vector2

func _ready() -> void:
	SignalBus.answerSubmitted.connect(check)
	SignalBus.startEvent.connect(start)
	initialPos = self.global_position

func start(id: int):
	if id != eventID:
		return
	customAnimator.floatIn(initialPos, 0.5)
	active = true

func check():
	if not active: return
	for slot: SchematicSlot in slots:
		if not slot.correct:
			return
	
	active = false
	customAnimator.floatOut(initialPos, 0.3)
	finish()
	
