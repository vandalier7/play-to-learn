extends Action

class_name SceneSwitchAction

@export var sceneName: String

func fireSignal():
	assert(sceneName in SceneManager.scenes.keys())
	SceneManager.switchScene(sceneName)
