extends Node

class_name CustomAnimator

# for tittering
@export var titterMagnitude: float = 5
@export var titterSpeed: float = 0.5

# for instant shaking
@export var shakeTime: float = 0.2
@export var shakeMagnitude: float = 3.0
@export var shakeSpeed: float = 6.0

var parent

var shakeTimer: float = 0.0

func _ready() -> void:
	assert(is_instance_valid(get_parent()))
	assert(is_instance_of(get_parent(), Node2D) or is_instance_of(get_parent(), Control))
	parent = get_parent()

func _process(delta: float) -> void:
	shakeProcess(delta)

var sineMultiplier: float = 0
func titter(value: bool):
	if not value:
		parent.rotation_degrees = lerp(parent.rotation_degrees, 0.0, 0.4)
		sineMultiplier = 0
	else:
		sineMultiplier += titterSpeed
		parent.rotation_degrees = sin(sineMultiplier) * titterMagnitude
		

func triggerShake() -> void:
	shakeTimer = shakeTime

func shakeProcess(delta: float) -> void:
	if shakeTimer > 0:
		shakeTimer = move_toward(shakeTimer, 0.0, delta)
		var progress: float = shakeTimer / shakeTime
		parent.rotation_degrees = sin(Time.get_ticks_msec() * 0.01 * shakeSpeed) * shakeMagnitude * progress
	else:
		parent.rotation_degrees = lerp(parent.rotation_degrees, 0.0, 0.2)

func snapTo(target: Vector2, speed: float) -> void:
	var tween = create_tween()
	tween.tween_property(parent, "global_position", target, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
