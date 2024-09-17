extends AppState

func on_enter():
	machine.set_state("AppStateInGame")

func on_exit():
	Events.curtain_fade_out.emit()
	get_tree().paused = false
	app_manager.game_started.emit()
