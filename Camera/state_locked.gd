extends CameraState

func on_enter():
	("locked")
	camera.current_lookahead = Vector2.ZERO

func on_process(delta: float):
	if camera.lockers.size() == 0:
		machine.set_state("StateFollowHero")
		return
	
	# Target acquisition 
	for top_locker in camera.lockers:
		if top_locker.axes == Constants.Axes.x:
			camera.target.x = top_locker.lock_position.x 
		elif top_locker.axes == Constants.Axes.y:
			camera.target.y = top_locker.lock_position.y
		elif top_locker.axes == Constants.Axes.both:
			camera.target = top_locker.lock_position
	
	# Move camera smoothly towards target
	camera.position = camera.lerpVector2(camera.position, camera.target, camera.current_lerp_ratio)
		
func on_process_physics(delta: float):
	pass

func on_exit():
	pass
