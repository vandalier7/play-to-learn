extends Line2D

class_name ElectricalWire

const GRID_SIZE: int = 1
const MIN_TRAVEL: float = 5.0

@onready var selection: Line2D = $Selection
@export var flowColor: Color = Color.DARK_BLUE

var waypoints: Array[Vector2] = []
var committedDir: Vector2 = Vector2.ZERO
var lastDir: Vector2
@export var targetPos: Vector2 = Vector2.ZERO
@export var targetFacingDir: Vector2 = Vector2.RIGHT

var startingNode: SchematicNode
var endingNode: SchematicNode
var voltage: float
var current: float

var isSelected: bool = false
var showFlow: bool = true

@onready var previewLine: Line2D = $PreviewLine

var origColor: Color
func _ready() -> void:
	origColor = default_color

func _snapToGrid(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / GRID_SIZE) * GRID_SIZE, round(pos.y / GRID_SIZE) * GRID_SIZE)

func _canTurn(a: Vector2, b: Vector2) -> bool:
	return a.distance_to(b) >= MIN_TRAVEL

func addWaypoint(globalPos: Vector2) -> void:
	if not is_instance_valid(startingNode):
		return
	var snapped: Vector2 = _snapToGrid(globalPos)
	if waypoints.is_empty():
		waypoints.append(snapped)
		return
	var end: Vector2 = _getCardinalEnd(waypoints.back(), snapped, committedDir)
	if not _canTurn(waypoints.back(), end):
		return
	lastDir = committedDir
	committedDir = (end - waypoints.back()).normalized()
	waypoints.append(end)

var hasStarted: bool = false
func _input(event: InputEvent) -> void:
	if not hasStarted and not is_instance_valid(General.ongoingLineConnection):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if isMouseOver() and General.phase in [General.Phase.Any, General.Phase.Wiring]:
				isSelected = !isSelected

	if not hasStarted:
		if event.is_action_pressed("Cancel") and isSelected:
			startingNode.connection = null
			endingNode.connection = null
			SignalBus.updateTopology.emit()
			queue_free()

	selection.visible = isSelected

	if hasStarted and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			addWaypoint(get_global_mouse_position())

	if hasStarted:
		if event.is_action_pressed("Cancel"):
			clearline()

func clearline():
	hasStarted = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	General.cursorMode = Input.CURSOR_ARROW
	queue_free()

func beginLine(pos: Vector2):
	hasStarted = true
	General.cursorMode = Input.CURSOR_CROSS
	addWaypoint(pos)

func endLine(pos: Vector2) -> bool:
	var remove = waypoints.pop_back()
	if waypoints.size() <= 0:
		waypoints.append(remove)
		return false
	committedDir = lastDir
	targetPos = pos

	for i in range(1):
		if not _routeToTarget(pos):
			var temp = waypoints.pop_back()
			if not _routeToTarget(pos):
				waypoints.append(temp)
		if waypoints.back().round() == pos.round():
			_rebuildLine()
			hasStarted = false
			General.cursorMode = Input.CURSOR_ARROW
			return true
	return false

func _routeToTarget(targetPosition: Vector2) -> bool:
	if waypoints.is_empty():
		return false
	var start: Vector2 = waypoints.back()
	var target: Vector2 = _snapToGrid(targetPosition)
	var segments: Array[Vector2] = _solveRoute(start, target, committedDir, Vector2.ZERO)
	if segments.is_empty():
		return false
	var currentDir: Vector2 = committedDir
	for i in range(1, segments.size()):
		var segDir: Vector2 = (segments[i] - segments[i - 1]).normalized()
		if currentDir != Vector2.ZERO and segDir == -currentDir:
			return false
		currentDir = segDir
		waypoints.append(segments[i])
	committedDir = currentDir
	_rebuildLine()
	previewLine.clear_points()
	return true

func _solveRoute(start: Vector2, target: Vector2, fromDir: Vector2, arrivalDir: Vector2) -> Array[Vector2]:
	var oneTurn: Array[Vector2] = _tryOneTurn(start, target, fromDir, arrivalDir)
	if not oneTurn.is_empty():
		return oneTurn
	var twoTurn: Array[Vector2] = _tryTwoTurns(start, target, fromDir, arrivalDir)
	if not twoTurn.is_empty():
		return twoTurn
	var threeTurn: Array[Vector2] = _tryThreeTurns(start, target, fromDir, arrivalDir)
	if not threeTurn.is_empty():
		return threeTurn
	return []

func _segmentsValidMinTravel(points: Array[Vector2]) -> bool:
	for i in range(points.size() - 1):
		if not _canTurn(points[i], points[i + 1]):
			return false
	return true

func _tryOneTurn(start: Vector2, target: Vector2, fromDir: Vector2, arrivalDir: Vector2) -> Array[Vector2]:
	var mid1: Vector2 = Vector2(target.x, start.y)
	var mid2: Vector2 = Vector2(start.x, target.y)
	
	var seg1Dir: Vector2 = (mid1 - start).normalized()
	if fromDir == Vector2.ZERO or seg1Dir != -fromDir:
		if seg1Dir != committedDir:
			var pts: Array[Vector2] = [start, mid1, target]
			if _segmentsValidMinTravel(pts):
				return pts
	
	var seg2Dir: Vector2 = (mid2 - start).normalized()
	if fromDir == Vector2.ZERO or seg2Dir != -fromDir:
		var pts: Array[Vector2] = [start, mid2, target]
		if _segmentsValidMinTravel(pts):
			return pts
	
	return []

func _tryTwoTurns(start: Vector2, target: Vector2, fromDir: Vector2, arrivalDir: Vector2) -> Array[Vector2]:
	return []

func _tryThreeTurns(start: Vector2, target: Vector2, fromDir: Vector2, arrivalDir: Vector2) -> Array[Vector2]:
	var m1: Vector2
	var m2: Vector2
	
	m2 = Vector2(start.x, target.y)
	m1 = Vector2(start.x, (start.y + target.y) / 2.0)
	if m1 == start or m2 == target or m1 == m2:
		m2 = Vector2(target.x, start.y)
		m1 = Vector2((start.x + target.x) / 2.0, start.y)
	if m1 == start or m2 == target or m1 == m2:
		return []
	var seg1Dir: Vector2 = (m1 - start).normalized()
	var seg2Dir: Vector2 = (m2 - m1).normalized()
	var seg3Dir: Vector2 = (target - m2).normalized()
	if fromDir != Vector2.ZERO and seg1Dir == -fromDir:
		return []
	if seg2Dir == -seg1Dir:
		return []
	if seg3Dir == -seg2Dir:
		return []
	var pts: Array[Vector2] = [start, m1, m2, target]
	if _segmentsValidMinTravel(pts):
		return pts
	return []

func _rebuildLine() -> void:
	clear_points()
	selection.clear_points()
	if waypoints.size() == 1:
		add_point(waypoints[0])
		return
	var buildDir: Vector2 = committedDir
	var fullPath: Array[Vector2] = []
	for i in waypoints.size() - 1:
		var a: Vector2 = waypoints[i]
		var b: Vector2 = waypoints[i + 1]
		var end: Vector2 = _getCardinalEnd(a, b, buildDir)
		buildDir = (end - a).normalized()
		if fullPath.is_empty() or fullPath.back() != a:
			fullPath.append(a)
		fullPath.append(end)
	for p in fullPath:
		add_point(p)
		selection.add_point(p)

func _rebuildPreview(preview: Vector2) -> void:
	if not hasStarted:
		return
	previewLine.clear_points()
	if waypoints.is_empty():
		return
	var a: Vector2 = waypoints.back()
	var end: Vector2 = _getCardinalEnd(a, preview, committedDir)
	if not _canTurn(a, end) and committedDir != Vector2.ZERO:
		if committedDir.x != 0:
			end = Vector2(preview.x, a.y)
			if sign(preview.x - a.x) != sign(committedDir.x):
				end = a
		else:
			end = Vector2(a.x, preview.y)
			if sign(preview.y - a.y) != sign(committedDir.y):
				end = a
	previewLine.add_point(a)
	previewLine.add_point(end)

func _process(_delta: float) -> void:
	if waypoints.is_empty():
		return
	var preview: Vector2 = _snapToGrid(get_global_mouse_position())
	if showFlow:
		if voltage > 0:
			default_color = lerp(default_color, flowColor, 0.3)
		else:
			default_color = lerp(default_color, origColor, 0.3)
	_rebuildLine()
	_rebuildPreview(preview)

func _getCardinalEnd(a: Vector2, b: Vector2, lastDir: Vector2) -> Vector2:
	var diff: Vector2 = b - a
	var horizontal: Vector2 = Vector2(b.x, a.y)
	var vertical: Vector2 = Vector2(a.x, b.y)
	var hDir: Vector2 = Vector2(sign(diff.x), 0)
	var vDir: Vector2 = Vector2(0, sign(diff.y))
	if lastDir != Vector2.ZERO:
		if hDir == -lastDir:
			return vertical
		if vDir == -lastDir:
			return horizontal
	if abs(diff.x) >= abs(diff.y):
		return horizontal
	return vertical

func isMouseOver() -> bool:
	var mouse: Vector2 = get_global_mouse_position()
	for i in get_point_count() - 1:
		var a: Vector2 = get_point_position(i)
		var b: Vector2 = get_point_position(i + 1)
		if _distanceToSegment(mouse, a, b) < 5.0:
			return true
	return false

func _distanceToSegment(point: Vector2, a: Vector2, b: Vector2) -> float:
	var ab: Vector2 = b - a
	var ap: Vector2 = point - a
	var t: float = clamp(ap.dot(ab) / ab.dot(ab), 0.0, 1.0)
	return point.distance_to(a + ab * t)
