## Attach as a child to any Sprite2D that is meant to be clicked on.
extends Area2D

class_name ClickableComponent

signal clicked
signal released
signal rightClicked

var clickable: bool = true
@export var disableHandCursor: bool = false

func _ready() -> void:
	input_event.connect(_onInputEvent)
	if not disableHandCursor:
		mouse_entered.connect(_onMouseEntered)
		mouse_exited.connect(_onMouseExited)

func _onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not clickable: return
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				clicked.emit()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				rightClicked.emit()
	get_viewport().set_input_as_handled()


func _onMouseEntered() -> void:
	if not clickable: return
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _onMouseExited() -> void:
	if not clickable: return
	Input.set_default_cursor_shape(General.cursorMode)

## Called by the parent of this Object. The Callable is then called whenever this object is clicked.
func setOnClickedFunction(callable: Callable) -> void:
	clicked.connect(callable)
