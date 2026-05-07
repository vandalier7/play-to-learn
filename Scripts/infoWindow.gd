extends Control

class_name InformationWindow

var startingPosition: Vector2

@onready var textureSchema: TextureRect = $Panel1/TextureRect
@onready var texture2D: TextureRect = $Panel2/TextureRect
@onready var title: RichTextLabel = $Title
@onready var description: RichTextLabel = $Description
@onready var customAnimator: CustomAnimator = $CustomAnimator

func _ready() -> void:
	customAnimator.floatOut(global_position, 0)
	startingPosition = global_position

func setTitleDesc(t: String, d: String):
	title.text = t
	description.text = d

func setTextures(schema: Texture2D, twoD: Texture2D):
	texture2D.texture = twoD
	textureSchema.texture = schema

func open():
	customAnimator.floatIn(startingPosition, 0.5)

func close():
	await customAnimator.floatOut(startingPosition, 0.3)
	SignalBus.componentInspected.emit()
