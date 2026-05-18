extends CharacterBody2D

class_name Player

const SPEED = 300.0
const STOP_RANGE: float = 5.0
const MOVEMENT_FALLOFF: float = 60

@onready var sprites: Array[Sprite2D] = [$Offseter/NoObjectSprite, $Offseter/WithObjectSprite]
@onready var animators: Array[AnimationPlayer] = [$Offseter/NoObjectSprite/AnimationPlayer, $Offseter/WithObjectSprite/AnimationPlayer]
@onready var offseter: Sprite2D = $Offseter
@onready var objectSlot: TextureRect = $Offseter/ObjectSlot/TextureRect
@onready var slotScanner: Area2D = $SlotScanner

var objectPacked: PackedScene
var objectName: String

var nearestSlot: ObjectSlot = null

func scanSlots() -> void:
	var nearest: ObjectSlot = null
	var nearestDist: float = INF
	
	if is_instance_valid(General.ongoingLineConnection) or General.phase not in [0, General.Phase.Placement]:
		nearestSlot = null
		return
	
	for area in slotScanner.get_overlapping_areas():
		if not is_instance_of(area.get_parent(), ObjectSlot):
			continue
		
		var d: float = slotScanner.global_position.distance_to(area.global_position)
		if d < nearestDist:
			nearestDist = d
			nearest = area.get_parent()
			#if is_instance_valid(nearest.object):
				#nearest = null
	nearestSlot = nearest


var targetPos: Vector2 = Vector2.INF
var isCarrying: bool = false

func _ready() -> void:
	SignalBus.playerGoTo.connect(goTo)
	SignalBus.objectPlaced.connect(place)

func place():
	if not is_instance_valid(nearestSlot) or objectPacked == null:
		return
	nearestSlot.placeObject(objectPacked.instantiate())

func goTo(pos: Vector2):
	targetPos = pos

func setFlip(value: bool):
	if value:
		offseter.rotation_degrees = 180
		offseter.scale.y = -1
	else:
		offseter.rotation_degrees = 0
		offseter.scale.y = 1

func playAnimation(anim: String):
	for anima in animators:
		assert(anima.has_animation(anim))
		anima.play(anim, -1, 1.5)

func _process(delta: float) -> void:
	if true:
		$Offseter/NoObjectSprite.visible = not isCarrying
		$Offseter/WithObjectSprite.visible = isCarrying
		$Offseter/ObjectSlot.visible = isCarrying
	
	if isCarrying:
		scanSlots()
	else:
		nearestSlot = null
	
	if is_instance_valid(nearestSlot):
		if is_instance_valid(nearestSlot.object) and nearestSlot.object.objectName == objectName:
			return
		SignalBus.playerIsOnSlot.emit()
		nearestSlot.titter()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(General.ongoingLineConnection) and Input.is_action_pressed("RightClicked"):
		if General.allowPlayerWalk:
			if get_global_mouse_position().y < 520 and get_global_mouse_position().y > 218:
				targetPos = get_global_mouse_position()
	
	
	
	if targetPos == Vector2.INF:
		playAnimation("RESET")
		move_and_slide()
		return
	
	var diff: Vector2 = targetPos - global_position
	var dist: float = diff.length()
	
	if dist <= STOP_RANGE:
		velocity = Vector2.ZERO
		targetPos = Vector2.INF
		playAnimation("RESET")
	else:
		var speedMulti: float = clamp((dist - STOP_RANGE) / MOVEMENT_FALLOFF, 0.0, 1.0)
		speedMulti = max(speedMulti, 0.4)
		velocity = diff.normalized() * SPEED * speedMulti
		for anima in animators:
			anima.speed_scale = 1.5 * speedMulti
		playAnimation("walk")
		if velocity.x != 0:
			setFlip(velocity.x < 0)
	
	move_and_slide()
