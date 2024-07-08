extends AppState

func on_enter():
	get_tree().paused = true

func on_process(_delta):
	if Input.is_action_just_pressed("unpause"):
		machine.set_state("AppStateInGame")

func on_exit():
	get_tree().paused = false
