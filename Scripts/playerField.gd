extends Sprite2D

@onready var clickable: ClickableComponent = $ClickableComponent


func onClicked():
	SignalBus.playerGoTo.emit(get_global_mouse_position())

func _process(delta: float) -> void:
	clickable.input_pickable = not is_instance_valid(General.ongoingLineConnection)
