extends AppState

func on_enter():
	RegionManager.change_region(AppManager.starting_region)
	AppManager.instantiate_hero()
	AppManager.instantiate_camera()
	await get_tree().process_frame
	machine.set_state("AppStateInGame")

func on_exit():
	UI.curtain.fade_out(0.5)
	get_tree().paused = false
	AppManager.game_started.emit()
