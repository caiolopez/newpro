extends AppState

func on_enter():
	var hud = load("res://GUI/Hud.tscn").instantiate()
	UI.add_child(hud)
	await get_tree().process_frame
	if SaveManager.load_from_slot():
		machine.set_state("AppStateInGame")
	else:
		machine.set_state("AppStateSplash")

func on_exit():
	Events.curtain_fade_out.emit()
	get_tree().paused = false
	app_manager.game_started.emit()
