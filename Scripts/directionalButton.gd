extends Control

class_name DirectionalButton

signal clicked

@onready var customAnimator: CustomAnimator = $DirectionalButton/CustomAnimator

@export var offset: Vector2 = Vector2(10, 0)

func onClick() -> void:
	if is_instance_valid(General.ongoingLineConnection): return
	customAnimator.lerpToOffset(offset)
	clicked.emit()

func _process(delta: float) -> void:
	if not Input.is_action_pressed("Clicked"):
		customAnimator.clearOffset()
