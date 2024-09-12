extends AppState

func on_enter():
	var hud = load("res://GUI/Hud.tscn").instantiate()
	UI.add_child(hud)
	await get_tree().process_frame
	SaveManager.load_from_slot()
	await get_tree().process_frame
	machine.set_state("AppStateInGame")

func on_exit():
	Events.curtain_fade_out.emit()
	app_manager.game_started.emit()
