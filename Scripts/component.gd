extends Node2D

class_name Component

@export var componentName: String
@export_multiline var description: String
@export var textureSchematic: Texture2D
@export var infoWindow: InformationWindow

@onready var clickableBehavior: ClickableComponent = $ClickableBehavior
@onready var sprite: Sprite2D = $Sprite2D
@onready var customAnimator: CustomAnimator = $CustomAnimator
@onready var glow: Glow = $Glow

var inspected: bool = false

func _ready() -> void:
	assert(is_instance_valid(sprite), "Please attach a Sprite2D to this object.")
	assert(is_instance_valid(infoWindow), "Please assign the Info Window object to this object.")
	assert(is_instance_valid(clickableBehavior), "Please attach a ClickableBehavior to this object.")
	assert(is_instance_valid(glow), "Please attach a Glow to this object.")
	clickableBehavior.setOnClickedFunction(click)

func click():
	inspected = true
	customAnimator.titterOnce(10, 0.04)
	infoWindow.setTitleDesc(componentName, description)
	infoWindow.setTextures(textureSchematic, sprite.texture)
	infoWindow.open()
	glow.stopGlowing()
