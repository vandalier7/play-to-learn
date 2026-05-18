extends Control

class_name InventoryItem

const increase: float = 0.2

@onready var rect: TextureRect = $NinePatchRect
@onready var texture: TextureRect = $NinePatchRect/TextureRect
@onready var playerInventory: Inventory = $"../../../.."

@export var objectTexture: Texture2D
@export var objectName: String
@export var object: PackedScene



var selected: bool = false

var initialMinimumSize: float
var initialScaleY: float

func _ready() -> void:
	initialMinimumSize = custom_minimum_size.x
	initialScaleY = rect.scale.y
	texture.texture = objectTexture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var targetMinimumSize = initialMinimumSize + (initialMinimumSize * increase * int(selected))
	var targetScaleY = initialScaleY + (initialScaleY * increase * int(selected))
	
	custom_minimum_size.x = lerp(custom_minimum_size.x, targetMinimumSize, 0.4)
	#custom_minimum_size.y = lerp(custom_minimum_size.y, targetMinimumSize, 0.4)
	rect.scale.y = lerp(rect.scale.y, targetScaleY, 0.4)
	texture.scale.x = lerp(texture.scale.x, targetScaleY, 0.4)
	

func onGuiInput(event: InputEvent) -> void:
	if is_instance_valid(General.ongoingLineConnection): return
	if event is InputEventMouseButton and event.pressed:
		if selected:
			selected = false
			playerInventory.displayItem(null)
		else:
			selected = true
			if objectName == "Compressor":
				SignalBus.emit_signal("compressorSelected")
			playerInventory.displayItem(self)
			playerInventory.deselectAll(self)
