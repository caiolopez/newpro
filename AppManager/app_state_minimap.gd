extends AppState

func on_enter():
	get_tree().paused = true

func on_process(_delta):
	if Input.is_action_just_released("minimap")\
	or Input.is_action_just_pressed("cancel")\
	or Input.is_action_just_pressed("pause"):
		if app_manager.minimap_node.hide_minimap():
			machine.set_state("AppStateInGame")

func on_exit():
	get_tree().paused = false
