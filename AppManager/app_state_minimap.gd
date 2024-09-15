extends AppState

func on_enter():
	get_tree().paused = true
	app_manager.game_paused.emit()

func on_process(_delta):
	if Input.is_action_just_released("minimap")\
	or Input.is_action_just_pressed("cancel"):
		if app_manager.minimap_node.hide_minimap():
			machine.set_state("AppStateInGame")

func on_exit():
	get_tree().paused = false
	app_manager.game_unpaused.emit()
