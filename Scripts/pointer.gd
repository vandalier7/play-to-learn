extends Control
@export_range(-180, 180) var angle: float = 0
@export var speed: float = 0.05
@export var magnitude: float = 10.0
var sineMultiplier: float = 0.0
var origin: Vector2

func _ready() -> void:
	rotation_degrees += angle
	origin = global_position

func _process(delta: float) -> void:
	sineMultiplier += speed
	var dir: Vector2 = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
	global_position = origin + dir * sin(sineMultiplier) * magnitude
