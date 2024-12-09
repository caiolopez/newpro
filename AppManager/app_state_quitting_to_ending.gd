extends AppState

func on_enter():
	get_tree().paused = true
	UI.get_node("Hud").force_hide_hud_elements()
	SaveManager.save_file()
	await UI.curtain.fade_in(0.5)
	get_node("/root/GameTree/Camera").queue_free()
	BackgroundManager.reset()
	if AppManager.hero:
		AppManager.hero.queue_free()
		AppManager.hero = null
	RegionManager.free_all_regions()
	AppManager.state_machine.set_state("AppStateEnding")
