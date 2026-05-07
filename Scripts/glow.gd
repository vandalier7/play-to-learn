extends Sprite2D

class_name Glow

@onready var customAnimator: CustomAnimator = $CustomAnimator

var initialScale: Vector2
var isGlowing: bool = true

func _ready() -> void:
	initialScale = scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	customAnimator.scalePulse(isGlowing, 0.1, 0.04, initialScale.x)

func stopGlowing():
	customAnimator.fadeOut(0.2)
	isGlowing = false
