extends ColorRect

@onready var customAnimator: CustomAnimator = $CustomAnimator


func _process(delta: float) -> void:
	if is_instance_valid(General.ongoingLineConnection):
		customAnimator.setAlpha(1)
	else:
		customAnimator.setAlpha(0)
		
