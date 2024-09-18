extends AppState

func on_enter():
	get_tree().paused = true
	Events.hide_hint.emit()
	SaveManager.save_file()
	await UI.curtain.fade_in(0.5)
	get_node("/root/GameTree/Camera").queue_free()
	AppManager.state_machine.set_state("AppStateMainMenu")
