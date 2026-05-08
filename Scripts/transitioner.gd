extends Control

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SignalBus.closeScene.connect(close)
	open()

func close():
	animationPlayer.play("sceneClose")

func open():
	animationPlayer.play("sceneOpen")
