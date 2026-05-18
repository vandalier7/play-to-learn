extends SimulationObject

class_name Switch3N

var switchedOn: bool = false 

func simulate() -> void:
	if not switchedOn:
		setOutputPressure(0)
		return
	
	super.simulate()

func toggle():
	switchedOn = !switchedOn
	
	$Sprite2D.frame = int(switchedOn)
