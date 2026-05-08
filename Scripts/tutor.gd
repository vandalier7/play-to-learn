extends Talker

class_name Tutor

@onready var talkerAnimator: CustomAnimator = $TextureRect/CustomAnimator
var initialPos: Vector2

func _ready() -> void:
	#nextAnimator.fadeOut(0)
	#backdropAnimator.fadeOut(0)
	talkerAnimator.hide()
	talkerAnimator.setVisible(false)
	#talkerAnimator.setScale(0)
	initialPos = global_position
	start(-1)

func start(id: int):
	if id != eventID:
		return
		
	customAnimator.floatIn(initialPos, APPEARANCE_SPEED)
	await get_tree().create_timer(1.7).timeout
	talkerAnimator.springIn(Vector2(1, 1), APPEARANCE_SPEED)
	#await get_tree().create_timer(0.7).timeout
	#backdropAnimator.fadeTo(Color(1.0, 1.0, 1.0), 0.5)
	#textAnimator.setText(lines[freshCounter])
	#await textAnimator.typewrite(revealInterval)
	#nextAnimator.fadeTo(Color.WHITE, 0.2)
	#finished = true

func next():
	pass

func prev():
	pass

func end():
	pass

func _process(delta: float) -> void:
	print(scale)
