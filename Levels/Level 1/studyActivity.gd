extends Activity

@export var components: Array[Component]

func _ready() -> void:
	SignalBus.componentInspected.connect(checkCompletion)

func checkCompletion():
	for comp: Component in components:
		if not comp.inspected:
			return
	finish()
	for comp: Component in components:
		comp.clickableBehavior.clickable = false
	
