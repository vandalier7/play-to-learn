extends Node

signal answerSubmitted
signal warn(text: String)
signal disallowSubmission(disallowed: bool)
signal startEvent(id: int)
signal eventEnded(id: int)
signal closeScene
signal actuated(componentName: String)

signal playerGoTo(globalPos: Vector2)
signal playerIsOnSlot
signal objectPlaced
signal objectSlotted
signal allowPlayerToWalk
signal disallowPlayerToWalk

signal updateTopology

# These are event signals.
signal componentInspected
signal compressorSelected # used in Level 3
signal wrongPlacement
signal correctPlacement
signal wireConnected

signal setPhaseToAny
signal setPhaseToPlacement
signal setPhaseToWiring
signal setPhaseToSimulation

signal playSimulation(play: bool) # sets phase to either Sim or SimPaused
signal stopSimulation # sets phase to Any

signal directorStaller

func tryTriggerEvent(object: Node):
	for child in object.get_children():
		if is_instance_of(child, EventSignal):
			var sig: EventSignal = child
			sig.fireSignal()
