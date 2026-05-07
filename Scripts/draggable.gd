extends Node2D

class_name Draggable

var isHolding: bool = false
var offset: Vector2 = Vector2.ZERO
@onready var area: Area2D = $DraggableArea
@onready var customAnimator: CustomAnimator = $CustomAnimator

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
		
