extends AppState

func on_enter():
	pass

func on_process(delta):
	AppManager.game_time += delta

	if AppManager.is_speedrun_mode:
		UI.game_time_label.text = Utils.parse_time_as_string(AppManager.game_time, false)

	if Input.is_action_just_pressed("pause"):
		machine.set_state("AppStatePausedInGame")

	if Input.is_action_just_pressed("minimap"):
		if AppManager.minimap_node.show_minimap():
			machine.set_state("AppStateMinimap")

func on_exit():
	pass
