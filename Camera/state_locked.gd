extends CameraState

func on_enter():
	pass

func on_process(_delta: float):
	if c.lockers.size() == 0:
		machine.set_state("StateFollowHero")
		return
		
func on_process_physics(_delta: float):
	pass

func on_exit():
	pass
