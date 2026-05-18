extends Talker

class_name Tutor

@onready var talkerAnimator: CustomAnimator = $TextureRect/CustomAnimator
@onready var nextButtonAnimator: CustomAnimator = $TutorialScreen/NextButton/CustomAnimator
@onready var prevButtonAnimator: CustomAnimator = $TutorialScreen/PrevButton/CustomAnimator
@onready var pages: Control = $Pages


var initialPos: Vector2
var isTutorSilent: bool = true
var visited: int = -1

var first: bool = true

func _ready() -> void:
	assert(is_instance_valid(pages))
	assert(pages.get_child_count() == lines.size())
	for page: Control in pages.get_children():
		if first: 
			first = false
			page.visible = true
			continue
		page.visible = false
	nextAnimator.fadeOut(0)
	customAnimator.fadeOut(0)
	backdropAnimator.fadeOut(0)
	talkerAnimator.hide()
	talkerAnimator.setVisible(false)
	nextButtonAnimator.fadeOut(0)
	prevButtonAnimator.fadeOut(0)
	#talkerAnimator.setScale(0)
	initialPos = global_position
	
	

func setTutorShown(value: bool):
	if value:
		isTutorSilent = false
		talkerAnimator.springIn(Vector2(1, 1), APPEARANCE_SPEED)
	else:
		isTutorSilent = true
		talkerAnimator.vanish(APPEARANCE_SPEED/2)

func start(id: int):
	if id != eventID:
		return
	await get_tree().create_timer(0.7).timeout
	customAnimator.floatIn(initialPos, APPEARANCE_SPEED)
	await get_tree().create_timer(.7).timeout
	setTutorShown(true)
	backdropAnimator.fadeTo(Color(1.0, 1.0, 1.0), 0.5)
	textAnimator.setText(lines[freshCounter])
	await textAnimator.typewrite(revealInterval)
	nextButtonAnimator.fadeTo(Color.WHITE, 0.2)
	if freshCounter != 0:
		prevButtonAnimator.fadeTo(Color.WHITE, 0.2)
	finished = true

func alreadyVisited() -> bool:
	return freshCounter <= visited

func next():
	if not finished:
		return
	nextButtonAnimator.triggerShake()
	if freshCounter == lines.size() - 1:
		end()
		return
	
	if not prevButtonAnimator.parent.visible:
		prevButtonAnimator.fadeTo(Color.WHITE, 0.2)
	
	pages.get_child(freshCounter).visible = false
	freshCounter += 1
	pages.get_child(freshCounter).visible = true

	if not alreadyVisited():
		nextButtonAnimator.fadeOut(0.2)
		prevButtonAnimator.fadeOut(0.2)
		finished = false
	
	
	
	if freshCounter >= lines.size():
		end()
		return
	if lines[freshCounter] != "":
		if isTutorSilent:
			setTutorShown(true)
		textAnimator.setText(lines[freshCounter], not alreadyVisited())
		if not alreadyVisited():
			await textAnimator.typewrite(revealInterval)
	else:
		if not isTutorSilent:
			setTutorShown(false)
		if not alreadyVisited():
			await get_tree().create_timer(1).timeout
	if not alreadyVisited():
		nextButtonAnimator.fadeTo(Color.WHITE, 0.2)
		prevButtonAnimator.fadeTo(Color.WHITE, 0.2)
	finished = true
	visited = max(freshCounter, visited)

func prev():
	if not finished or freshCounter == 0:
		return
	#nextButtonAnimator.triggerShake()
	prevButtonAnimator.triggerShake()
	
	pages.get_child(freshCounter).visible = false
	freshCounter -= 1
	pages.get_child(freshCounter).visible = true
	
	if freshCounter == 0:
		prevButtonAnimator.fadeOut(0.2)
	
	if not alreadyVisited():
		nextButtonAnimator.fadeOut(0.2)
		prevButtonAnimator.fadeOut(0.2)
		finished = false
	
	
	
	if freshCounter >= lines.size():
		end()
		return
	if lines[freshCounter] != "":
		if isTutorSilent:
			setTutorShown(true)
		textAnimator.setText(lines[freshCounter], not alreadyVisited())
		if not alreadyVisited():
			await textAnimator.typewrite(revealInterval)
	else:
		if not isTutorSilent:
			setTutorShown(false)
	if not alreadyVisited():
		nextButtonAnimator.fadeTo(Color.WHITE, 0.2)
		if freshCounter != 0:
			prevButtonAnimator.fadeTo(Color.WHITE, 0.2)
	finished = true
	visited = max(freshCounter, visited)

func end():
	super.end()
