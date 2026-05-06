extends Area2D

func _ready() -> void:
	assert(is_instance_of(get_parent(), Draggable), "Parent must be of type Draggable!")
	var parent: Draggable = get_parent()
	input_event.connect(parent.onInputEvent)
	mouse_entered.connect(parent.onMouseEntered)
	mouse_exited.connect(parent.onMouseExited)
	
	if is_instance_of(parent, SlotObject):
		pass
