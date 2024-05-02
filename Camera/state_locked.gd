extends CameraState

func on_enter():
	("locked")
	

func on_process(delta: float):
	if camera.lockers.size() == 0:
		machine.set_state("StateFollowHero")
		return
	
	camera.position = camera.hero.position
	
	for top_locker in camera.lockers:
		if top_locker.axes == Constants.Axes.x:
			camera.position.x = top_locker.lock_position.x 
		elif top_locker.axes == Constants.Axes.y:
			camera.position.y = top_locker.lock_position.y
		elif top_locker.axes == Constants.Axes.both:
			camera.position = top_locker.lock_position
		
func on_process_physics(delta: float):
	pass

func on_exit():
	pass
