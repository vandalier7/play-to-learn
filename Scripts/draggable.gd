extends Node2D

class_name Draggable

const SHAKE_MAGNITUDE: float = 5
const SHAKE_SPEED: float = 0.5

var isHolding: bool = false
var offset: Vector2 = Vector2.ZERO
@onready var area: Area2D = $DraggableArea

func _process(delta: float) -> void:
	if isHolding and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		isHolding = false
	if isHolding:
		z_index = 5
		global_position = get_global_mouse_position() + offset
	else:
		z_index = 0
	isHoldingLastFrame = isHolding


func onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		isHolding = event.pressed
		if isHolding:
			offset = - get_global_mouse_position() + global_position
	get_viewport().set_input_as_handled()

var isHoldingLastFrame: bool = false
func hasJustLetGo() -> bool:
	return isHoldingLastFrame and not isHolding
	
func onMouseEntered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	#get_viewport().set_input_as_handled()

func onMouseExited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	#get_viewport().set_input_as_handled()
		

func snapTo(target: Vector2, speed: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

var sineMultiplier: float = 0
func shake(value: bool):
	if not value:
		rotation_degrees = lerp(rotation_degrees, 0.0, 0.4)
		sineMultiplier = 0
	else:
		sineMultiplier += SHAKE_SPEED
		rotation_degrees = sin(sineMultiplier) * SHAKE_MAGNITUDE
