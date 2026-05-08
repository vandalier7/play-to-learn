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
	targetScale = parent.scale

func _process(delta: float) -> void:
	shakeProcess(delta)
	parent.scale = lerp(parent.scale, targetScale, 0.3)

var targetScale: Vector2
func setScale(scale: float):
	targetScale = Vector2(scale, scale)

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

func hide() -> void:
	parent.scale = Vector2.ZERO

func springIn(targetScale: Vector2, speed: float) -> void:
	setVisible(true)
	var tween = create_tween()
	tween.tween_property(parent, "scale", targetScale * 1.2, speed * 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "scale", targetScale, speed * 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
func vanish(speed: float) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(parent, "scale", Vector2.ZERO, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "modulate:a", 0.0, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	setVisible(false)

func fadeTo(color: Color, time: float) -> void:
	setVisible(true)
	var tween = create_tween()
	tween.tween_property(parent, "modulate", color, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

	
func fadeOut(time: float) -> void:
	var tween = create_tween()
	tween.tween_property(parent, "modulate:a", 0.0, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	setVisible(false)

func setVisible(value: bool):
	parent.visible = value

func floatIn(targetPos: Vector2, duration: float, offset: Vector2 = Vector2(0, -20)) -> void:
	setVisible(true)
	parent.global_position = targetPos + offset
	parent.modulate.a = 0.0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(parent, "global_position", targetPos, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "modulate:a", 1.0, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	

func floatOut(targetPos: Vector2, duration: float, offset: Vector2 = Vector2(0, 20)) -> void:
	parent.modulate.a = 1.0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(parent, "global_position", targetPos + offset, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "modulate:a", 0.0, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	setVisible(false)

func titterOnce(magnitude: float, speed: float) -> void:
	var tween = create_tween()
	tween.tween_property(parent, "rotation_degrees", magnitude, speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "rotation_degrees", -magnitude, speed * 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "rotation_degrees", 0.0, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

var scaleSineMultiplier: float = 0
func scalePulse(value: bool, speed: float, magnitude: float, equilibrium: float) -> void:
	if not value:
		parent.scale = lerp(parent.scale, Vector2.ONE * equilibrium, 0.4)
		scaleSineMultiplier = 0
	else:
		scaleSineMultiplier += speed
		var s: float = equilibrium + sin(scaleSineMultiplier) * magnitude
		parent.scale = Vector2(s, s)
