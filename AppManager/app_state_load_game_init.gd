extends AppState

func on_enter():
	AppManager.instantiate_hero()
	AppManager.instantiate_camera()
	await get_tree().process_frame
	if SaveManager.load_from_slot():
		machine.set_state("AppStateInGame")
	else:
		machine.set_state("AppStateSplash")

func on_exit():
	UI.curtain.fade_out(0.5)
	get_tree().paused = false
	AppManager.game_started.emit()
