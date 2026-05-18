extends SimulationObject

class_name AirTankReservoir

func simulate() -> void:
	if not is_instance_valid(inputPorts[0].connection):
		setOutputPressure(0)
		return
	if not is_instance_of(inputPorts[0].connection.get_parent(), Compressor):
		setOutputPressure(0)
		return
	setOutputPressure(getInputPressure())
