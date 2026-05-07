## Attach as a child to any Sprite2D that is meant to be clicked on.
extends Area2D

class_name ClickableComponent

signal clicked

func _ready() -> void:
	input_event.connect(_onInputEvent)
	mouse_entered.connect(_onMouseEntered)
	mouse_exited.connect(_onMouseExited)

func _onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()

func _onMouseEntered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _onMouseExited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

## Called by the parent of this Object. The Callable is then called whenever this object is clicked.
func setOnClickedFunction(callable: Callable) -> void:
	clicked.connect(callable)
