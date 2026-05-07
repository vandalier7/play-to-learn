extends Sprite2D
@export var frameInterval: float = 0.1

var frames: int
var frameTimer: float = 0.0

func _ready() -> void:
	frames = hframes * vframes

func _process(delta: float) -> void:
	frameTimer += delta
	if frameTimer >= frameInterval:
		frameTimer = 0.0
		frame = (frame + 1) % frames
