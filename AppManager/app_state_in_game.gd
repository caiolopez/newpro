extends AppState

func on_enter():
	get_tree().paused = false
	if DebugTools.print_stuff: print("Game Unpaused.")

func on_process(delta):
	app_manager.game_time += delta

func on_exit():
	pass
