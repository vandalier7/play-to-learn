extends Node

class_name Activity

var eventID: int = -1
var active: bool = false

func prepare(id: int):
	eventID = id

func finish():
	SignalBus.eventEnded.emit(eventID)
