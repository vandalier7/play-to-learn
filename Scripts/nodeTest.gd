extends Sprite2D

class_name SchematicNode

@onready var clickable: ClickableComponent = $ClickableComponent
@export var lineObject: PackedScene = preload("res://Objects/wire.tscn")

@export var portDirection: Vector2i = Vector2i.DOWN
@export var lineColor: Color = Color.TRANSPARENT
@export var gray: Color = Color("989898")

var connection: SchematicNode
var line: Wire
var isOutput: bool = false
var isElectric: bool = false

func _ready() -> void:
	showDirectional()

func setInputOutput(output: bool):
	$Directional.flip_h = output
	isOutput = output
	if output:
		directional.modulate = Color.GREEN

@onready var directional: Sprite2D = $Directional
func showDirectional():
	if portDirection == Vector2i.DOWN:
		directional.rotation_degrees = -90
	if portDirection == Vector2i.LEFT:
		directional.rotation_degrees = 0
	if portDirection == Vector2i.UP:
		directional.rotation_degrees = 90
	if portDirection == Vector2i.RIGHT:
		directional.rotation_degrees = 180

func onClicked():
	if is_instance_valid(connection) and not isElectric:
		return
	
	if General.phase not in [General.Phase.Any, General.Phase.Wiring]:
		return

	if not isElectric and not is_instance_valid(line) and not is_instance_valid(General.ongoingLineConnection):
		line = lineObject.instantiate()
		General.ongoingLineConnection = line
		get_tree().current_scene.add_child(line)
		line.global_position = Vector2.ZERO
	elif isElectric:
		if not is_instance_valid(General.ongoingLineConnection):
			line = lineObject.instantiate()
			General.ongoingLineConnection = line
			get_tree().current_scene.add_child(line)
			line.global_position = Vector2.ZERO
	
	if not is_instance_valid(General.ongoingLineConnection):
		return
	
	line = General.ongoingLineConnection
	
	if not line.hasStarted:
		if not isOutput: 
			General.ongoingLineConnection = null
			line = null
			return
		if lineColor != Color.TRANSPARENT:
			line.default_color = lineColor
			line.showFlow = false
		line.requiredStartingDirection = portDirection
		line.startingNode = self
		line.beginLine(global_position)
	else:
		if isOutput: return
		if line.startingNode == self:
			line = null
			return
		if line.startingNode.isElectric != isElectric:
			line = null
			return
		if line.endLine(global_position, -portDirection):
			connection = line.startingNode
			line.startingNode.connection = self
			line.endingNode = self
			General.ongoingLineConnection = null
			SignalBus.updateTopology.emit()
		else:
			line = null
	
	#if is_instance_valid(line):
		#print(true)

func intake():
	return line.pressure

func release(pressure: float):
	line.pressure = pressure

func disconnectWire():
	if not is_instance_valid(connection):
		return
	line.queue_free()
	connection = null
