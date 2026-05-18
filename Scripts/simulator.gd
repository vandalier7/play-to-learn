extends Activity

class_name Simulator

var allComponents: Array[Node]

var orderedComponents: Array[SimulationObject]
@export var requiredComponentOrder: Array[String] = []

func _ready() -> void:
	allComponents = get_tree().get_nodes_in_group("Simulation Objects")
	SignalBus.updateTopology.connect(updateTopology)

func getTopologicalOrder() -> Array[SimulationObject]:
	allComponents = get_tree().get_nodes_in_group("Simulation Objects")
	var result: Array[SimulationObject] = []
	var visited: Array[SimulationObject] = []
	
	for component in allComponents:
		_visit(component, visited, result)
	
	return result

func onWireConnected():
	var result = checkOrder()
	if result == -1:
		SignalBus.warn.emit("Incorrect connection!")
	elif result == 1:
		SignalBus.wireConnected.emit()
	elif result == 2:
		finish()

func checkOrder() -> int:
	if compressorFirst.is_empty():
		return 1
	var names: Array[String] = []
	for component in compressorFirst:
		names.append(component.objectName)
	
	if names.size() <= 1:
		return 0
	if names.size() > requiredComponentOrder.size():
		return -1
	
	if requiredComponentOrder == names:
		return 2
	
	var trimmed: Array[String] = requiredComponentOrder.slice(0, names.size())
	if trimmed == names:
		return 1
	else: return -1

func _visit(node: SimulationObject, visited: Array, result: Array) -> void:
	if visited.has(node):
		return
	visited.append(node)
	for port in node.inputPorts:
		if is_instance_valid(port.connection) and is_instance_valid(port.connection.get_parent()):
			var upstream: SimulationObject = port.connection.get_parent()
			_visit(upstream, visited, result)
	result.append(node)

var compressorFirst: Array[SimulationObject] = []

func getCompressorFirst() -> Array[SimulationObject]:
	var result: Array[SimulationObject] = []
	var compressors: Array[SimulationObject] = []
	
	for component in orderedComponents:
		if component.objectName.begins_with("Compressor"):
			compressors.append(component)
	
	var reachable: Array[SimulationObject] = []
	for compressor in compressors:
		_collectReachable(compressor, reachable)
	
	for component in compressors:
		result.append(component)
	for component in orderedComponents:
		if component in reachable and component not in compressors:
			result.append(component)
	
	compressorFirst = result
	return result

func _collectReachable(node: SimulationObject, reachable: Array) -> void:
	if node in reachable:
		return
	reachable.append(node)
	for port in node.outputPorts:
		if is_instance_valid(port.connection) and is_instance_valid(port.connection.get_parent()):
			var downstream: SimulationObject = port.connection.get_parent()
			_collectReachable(downstream, reachable)

func _process(delta: float) -> void:
	if General.phase not in [0, General.Phase.Simulation]:
		return
	for component in orderedComponents:
		if not is_instance_valid(component):
			updateTopology()
			break
		component.simulate()

func updateTopology():
		orderedComponents = getTopologicalOrder()
		getCompressorFirst()
		onWireConnected()

func setSimulationPaused(paused: bool):
	if paused:
		General.phase = General.Phase.SimulationPaused
	else:
		General.phase = General.Phase.Simulation

func stopSimulation():
		General.phase = General.Phase.Wiring
	
