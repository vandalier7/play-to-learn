extends Control

@onready var customAnimator: CustomAnimator = $CustomAnimator

@export var isToggle: bool = false
@export var signalName: String
@export var hideIfNotSimulating: bool = false
@export var resetOnStopped: bool = false

var toggledOn: bool = false

func _ready() -> void:
	if signalName == "": return
	assert(SignalBus.has_signal(signalName))
	SignalBus.playSimulation.connect(showSelf)
	SignalBus.stopSimulation.connect(reset)

func onGuiInput(event: InputEvent) -> void:
	if signalName == "": return
	if event.is_action_pressed("Clicked"):
		customAnimator.triggerShake()
		
		if not isToggle:
			SignalBus.emit_signal(signalName)
			if hideIfNotSimulating:
				visible = false
		else:
			toggledOn = not toggledOn
			SignalBus.emit_signal(signalName, toggledOn)
			$"../TextureRect4/TextureRect4".visible = toggledOn
		
func showSelf(value: bool):
	visible = true

func reset():
	toggledOn = false
	$"../TextureRect4/TextureRect4".visible = toggledOn
