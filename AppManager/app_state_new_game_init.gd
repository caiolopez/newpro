extends AppState

func on_enter():
	machine.set_state("AppStateInGame")

func on_exit():
	UI.curtain.fade_out(0.5)
	get_tree().paused = false
	AppManager.game_started.emit()
