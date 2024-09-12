extends AppState

func on_enter():
	get_tree().paused = true
	app_manager.game_paused.emit()
	if DebugTools.print_stuff: print("Game Paused.")

func on_exit():
	get_tree().paused = false
	app_manager.game_unpaused.emit()
	if DebugTools.print_stuff: print("Game Unpaused.")
