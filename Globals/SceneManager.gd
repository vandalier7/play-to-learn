extends Node

var scenes: Dictionary = {
	"menu" : "res://Levels/menu.tscn",
	"level1" : "res://Levels/Level 1/level1.tscn"
}

var canvasLayer: CanvasLayer
var blackOverlay: ColorRect

func _ready() -> void:
	# Create the UI overlay that persists between scenes
	canvasLayer = CanvasLayer.new()
	canvasLayer.layer = 100
	add_child(canvasLayer)
	
	blackOverlay = ColorRect.new()
	blackOverlay.color = Color.BLACK
	blackOverlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	blackOverlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	blackOverlay.modulate.a = 0 # Start invisible
	canvasLayer.add_child(blackOverlay)

func switchScene(sceneKey: String) -> void:
	assert(scenes.has(sceneKey))
	var path = scenes[sceneKey]
	await get_tree().create_timer(1.0).timeout
	blackOverlay.modulate.a = 1
	call_deferred("_deferredSwitch", path)
	

func _deferredSwitch(path: String) -> void:
	var nextScene = load(path)
	if nextScene:
		get_tree().change_scene_to_packed(nextScene)
		await get_tree().process_frame
		blackOverlay.modulate.a = 0
		
