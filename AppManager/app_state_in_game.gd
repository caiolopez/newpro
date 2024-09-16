extends AppState

func on_enter():
	pass

func on_process(delta):
	app_manager.game_time += delta

	if Input.is_action_just_pressed("pause"):
		machine.set_state("AppStatePaused")

	if Input.is_action_just_pressed("minimap"):
		if app_manager.minimap_node.show_minimap():
			machine.set_state("AppStateMinimap")

	if app_manager.is_speedrun_mode:
		UI.game_time_label.text = Utils.parse_time_as_string(AppManager.game_time, false)

func on_exit():
	pass
