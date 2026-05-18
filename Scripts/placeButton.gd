extends Button

@onready var customAnimator: CustomAnimator = $CustomAnimator

func _ready() -> void:
	customAnimator.fadeOut(0)
