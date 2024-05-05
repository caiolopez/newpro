extends CameraState

func on_enter():
	pass

func on_process(delta: float):
	if camera.lockers.size() == 0:
		machine.set_state("StateFollowHero")
		return
		
func on_process_physics(delta: float):
	pass

func on_exit():
	pass
