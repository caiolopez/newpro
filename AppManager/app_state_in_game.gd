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

func on_exit():
	pass
