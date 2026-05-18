extends SimulationObject

class_name SingleActingPiston

var toggleFlag: bool = false
@onready var animator: AnimationPlayer = $AnimationPlayer


func simulate() -> void:
	if getInputPressure() > 0:
		if not toggleFlag:
			toggleFlag = true
			customAnimator.triggerShake()
			animator.play("open")
			SignalBus.actuated.emit(objectName)
	else:
		if toggleFlag:
			toggleFlag = false
			customAnimator.triggerShake()
			animator.play("open", -1, -1, true)
