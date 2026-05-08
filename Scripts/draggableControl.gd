extends Control
class_name DraggableControl

var isHolding: bool = false
var offset: Vector2 = Vector2.ZERO
var isHoldingLastFrame: bool = false

func _ready() -> void:
	gui_input.connect(onGuiInput)

func _process(delta: float) -> void:
	if isHolding and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		isHolding = false
	if isHolding:
		get_parent().z_index = 5
		get_parent().global_position = get_global_mouse_position() + (offset * get_parent().scale)
	else:
		get_parent().z_index = 0
	isHoldingLastFrame = isHolding

func onGuiInput(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		isHolding = event.pressed
		if isHolding:
			offset = -get_global_mouse_position() + get_parent().global_position
	get_viewport().set_input_as_handled()

func hasJustLetGo() -> bool:
	return isHoldingLastFrame and not isHolding
