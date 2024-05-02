extends CameraState

func on_enter():
	camera.position = camera.hero.global_position

func on_process(delta: float):
	if camera.lockers.size() > 0:
		machine.set_state("StateLocked")
		return
	camera.position = camera.hero.global_position

func on_process_physics(delta: float):
	pass

func on_exit():
	pass
