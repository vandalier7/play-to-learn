extends Button

class_name SubmitButton

@onready var customAnimator: CustomAnimator = $CustomAnimator

func _ready() -> void:
	pressed.connect(func(): SignalBus.answerSubmitted.emit())
	SignalBus.disallowSubmission.connect(setDisabled)

func setDisabled(value: bool):
	if disabled != value:
		customAnimator.triggerShake()
	disabled = value
	if disabled:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
