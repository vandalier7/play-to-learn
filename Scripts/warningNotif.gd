extends Control

@onready var customAnimator: CustomAnimator = $Panel/CustomAnimator

var notifPos: Vector2
const notifDuration: float = 2.5
var notifTime: float = 0

func _ready() -> void:
	notifPos = $Panel.global_position
	customAnimator.floatOut(notifPos, 0.0)
	SignalBus.warn.connect(notify)

func notify(text: String):
	if flag:
		await customAnimator.floatOut(notifPos, 0.2)
	notifTime = notifDuration
	flag = true
	$Panel/RichTextLabel.text = text
	customAnimator.floatIn(notifPos, 0.2)
	

var flag: bool = false
func _process(delta: float) -> void:
	notifTime = move_toward(notifTime, 0, delta)
	if notifTime == 0 and flag:
		customAnimator.floatOut(notifPos, 0.2)
		flag = false
