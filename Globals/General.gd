extends Node

var cursorMode: int = 0
var ongoingLineConnection: Wire = null

var allowPlayerWalk: bool = true
var phase: Phase = Phase.Any

enum Phase {
	Any,
	Placement,
	Wiring,
	Simulation,
	SimulationPaused,
	SimulationStopped
}

func _ready() -> void:
	SignalBus.allowPlayerToWalk.connect(allowPlayerToWalk)
	SignalBus.disallowPlayerToWalk.connect(disallowPlayerToWalk)
	SignalBus.setPhaseToAny.connect(setPhaseToAny)
	SignalBus.setPhaseToPlacement.connect(setPhaseToPlacement)
	SignalBus.setPhaseToSimulation.connect(setPhaseToSimulation)
	SignalBus.setPhaseToWiring.connect(setPhaseToWiring)
	SignalBus.playSimulation.connect(setSimulationPlaying)
	SignalBus.stopSimulation.connect(stopSimulation)

func allowPlayerToWalk():
	allowPlayerWalk = true

func disallowPlayerToWalk():
	allowPlayerWalk = false

func setPhaseToPlacement():
	phase = Phase.Placement
	
func setPhaseToAny():
	phase = Phase.Any
	
func setPhaseToWiring():
	phase = Phase.Wiring

func setPhaseToSimulation():
	phase = Phase.Simulation

func stopSimulation():
	phase = Phase.Any

func setSimulationPlaying(isPlaying: bool):
	if isPlaying:
		phase = Phase.Simulation
	else:
		phase = Phase.SimulationPaused
		
