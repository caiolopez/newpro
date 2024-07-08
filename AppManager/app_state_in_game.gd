extends AppState

func on_enter():
	pass

func on_process(_delta):
	if Input.is_action_just_pressed("pause"):
		machine.set_state("AppStatePaused")

func on_exit():
	pass
