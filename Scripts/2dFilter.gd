## Attach as a child to any Sprite2D that is meant to be clicked on.
extends Area2D

func _ready() -> void:
	input_event.connect(_onInputEvent)


func _onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled()
