extends AppState

func on_enter():
	pass

func on_process(delta):
	app_manager.game_time += delta

func on_exit():
	pass
