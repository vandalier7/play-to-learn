extends Button

func play():
	SignalBus.closeScene.emit()
	SceneManager.switchScene("level3")
