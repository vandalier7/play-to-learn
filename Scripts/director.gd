extends Node

class_name Director

@export var sequence: Array[Node]
var currentEventID: int = 0
var eventDelay: float = 0.0

func _ready() -> void:
	SignalBus.eventEnded.connect(eventEnded)
	var id: int = 0
	for actor: Node in sequence:
		assert(isActor(actor))
		if is_instance_of(actor, Talker):
			var talker: Talker = actor
			talker.prepare(id)
		if is_instance_of(actor, EventSignal):
			var event: EventSignal = actor
			event.prepare(id)
		if is_instance_of(actor, Activity):
			var activity: Activity = actor
			activity.prepare(id)
		if is_instance_of(actor, Action):
			var action: Action = actor
			action.prepare(id)
		
		id += 1
	await get_tree().create_timer(1).timeout
	SignalBus.startEvent.emit(currentEventID)

func isActor(actor: Node) -> bool:
	if not is_instance_of(actor, Talker) and not is_instance_of(actor, Action) and not is_instance_of(actor, Activity) and not is_instance_of(actor, EventSignal):
		return false
	return true

func eventEnded(eventID):
	if eventID != currentEventID:
		return
	currentEventID += 1
	await get_tree().create_timer(eventDelay).timeout
	if currentEventID > sequence.size() - 1:
		SignalBus.closeScene.emit()
		SceneManager.switchScene("menu")
		return
	
	SignalBus.startEvent.emit(currentEventID)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
