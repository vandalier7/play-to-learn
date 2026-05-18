extends SimulationObject

class_name Button3N


var switchedOn: bool = false 

func simulate() -> void:
	if not switchedOn:
		setOutputPressure(0)
		return
	
	super.simulate()

func turnOn():
	switchedOn = true
	$Sprite2D.frame = 1

func turnOff():
	switchedOn = false
	$Sprite2D.frame = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			turnOff()
