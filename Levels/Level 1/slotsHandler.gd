extends Node2D

class_name SlotsHandler

var slots: Array[Slot]

func _ready() -> void:
	for node in get_children():
		if is_instance_of(node, Slot):
			slots.append(node)

func ensureSlotsFilled():
	var filled: bool = true
	for slot: Slot in slots:
		if not slot.hasObject():
			filled = false
			SignalBus.disallowSubmission.emit(true)
			return
	SignalBus.disallowSubmission.emit(false)
