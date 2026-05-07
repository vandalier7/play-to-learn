extends Node

class_name Activity

var eventID: int = -1

func prepare(id: int):
	eventID = id

func finish():
	SignalBus.eventEnded.emit(eventID)
