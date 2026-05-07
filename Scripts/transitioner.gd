extends Control

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	open()

func close():
	animationPlayer.play("sceneClose")

func open():
	animationPlayer.play("sceneOpen")
