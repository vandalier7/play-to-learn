## The talker guy. Each event of this guy talking must be its own object.
extends Control

class_name Talker

const APPEARANCE_SPEED: float = 0.3

@export var revealInterval: float = 0.02
@export_multiline var lines: PackedStringArray

@onready var customAnimator: CustomAnimator = $CustomAnimator
@onready var textAnimator: DialogueAnimator = $TextureRect/Dialogue/DialogueAnimator
@onready var nextAnimator: CustomAnimator = $TextureRect/NextButton/CustomAnimator
@onready var backdropAnimator: CustomAnimator = $Backdrop/CustomAnimator


var eventID: int = -1
var freshCounter: int = 0
var finished: bool = false

func _ready() -> void:
	customAnimator.hide()
	nextAnimator.fadeOut(0)
	backdropAnimator.fadeOut(0)

func prepare(id: int):
	eventID = id
	SignalBus.startEvent.connect(start)
	
func start(id: int):
	if id != eventID:
		return
		
	
	customAnimator.springIn(Vector2.ONE, APPEARANCE_SPEED)
	await get_tree().create_timer(0.7).timeout
	backdropAnimator.fadeTo(Color(1.0, 1.0, 1.0), 0.5)
	textAnimator.setText(lines[freshCounter])
	await textAnimator.typewrite(revealInterval)
	nextAnimator.fadeTo(Color.WHITE, 0.2)
	finished = true

func next():
	if not finished:
		return
	nextAnimator.triggerShake()
	nextAnimator.fadeOut(0.2)
	finished = false
	freshCounter += 1
	
	if freshCounter >= lines.size():
		end()
		return
	
	textAnimator.setText(lines[freshCounter])
	await textAnimator.typewrite(revealInterval)
	nextAnimator.fadeTo(Color.WHITE, 0.2)
	finished = true

func end():
	await backdropAnimator.fadeOut(0.2)
	await customAnimator.vanish(APPEARANCE_SPEED)
	SignalBus.eventEnded.emit(eventID)
	
	visible = false
	
