extends Control

class_name Inventory

var invSlots: Array[InventoryItem]

@export var player: Player

@onready var customLabelAnimator: CustomAnimator = $NinePatchRect2/CustomAnimator
@onready var itemLabel: RichTextLabel = $NinePatchRect2/RichTextLabel
@onready var buttons: Array[DirectionalButton] = [$NinePatchRect/Next, $NinePatchRect/Prev]
@onready var customButtonAnimator: CustomAnimator = $PlaceButton/CustomAnimator


var page: int = 0
var pages: int = 1

func _ready() -> void:
	for grandchild in $PanelContainer/MarginContainer/HBoxContainer.get_children():
		invSlots.append(grandchild)
	
	pages = floori(invSlots.size() / 5) + 1
	customLabelAnimator.setAlpha(0)
	SignalBus.playerIsOnSlot.connect(onSlotHeartbeat)
	
	if invSlots.size() <= 5:
		for button in buttons:
			button.visible = false

var lastHeartbeat: int = 0
var heartbeat: int = 0
func onSlotHeartbeat():
	heartbeat += 1

func hasHeartbeat() -> bool:
	return heartbeat != lastHeartbeat

func pageChanged():
	for invSlot in invSlots:
		invSlot.visible = false
	for i in range(page * 5, (page * 5) + 5):
		if not i < invSlots.size():
			break
		invSlots[i].visible = true
	deselectAll(null)
	displayItem(null)

func deselectAll(except: InventoryItem):
	for item in invSlots:
		if item == except:
			continue
		item.selected = false

func displayItem(item: InventoryItem):
	if not is_instance_valid(item):
		player.isCarrying = false
		customLabelAnimator.setAlpha(0)
		player.objectPacked = null
		return
	player.objectSlot.texture = item.objectTexture
	player.isCarrying = true
	customLabelAnimator.setAlpha(1)
	itemLabel.text = item.objectName
	player.objectPacked = item.object
	player.objectName = item.objectName
	
	

func getSelectedItem() -> InventoryItem:
	for item in invSlots:
		if item.selected:
			return item
	return null


func next():
	page += 1
	page = page % pages
	pageChanged()

func place() -> void:
	SignalBus.objectPlaced.emit()

func prev():
	page += 1
	page = page % pages
	pageChanged()

var heartbeatFlag: bool = false
func _process(delta: float) -> void:
	if not hasHeartbeat():
		if heartbeat != 0:
			heartbeat = 0
			heartbeatFlag = false
			customButtonAnimator.fadeOut(0.1)
	else:
		if not heartbeatFlag:
			heartbeatFlag = true
			customButtonAnimator.fadeTo(Color.WHITE, 0.1)
			
			
		
	lastHeartbeat = heartbeat
	
