extends CameraState

func on_enter():
	pass

func on_process(delta: float):
	
	var hero_vel = camera.hero.get_velocity()
	var hero_dir = camera.hero.facing_direction
	var la_amount = camera.lookahead_amount
	
	# Lerp Lerp Smoothing
	if abs(hero_vel.x) < camera.catch_up_vel.x:
		camera.current_lerp_ratio.x = camera.lerp_ratio.x
	else: camera.current_lerp_ratio.x = lerp(camera.current_lerp_ratio.x, 1.0, 0.01)
		
	if abs(hero_vel.y) < camera.catch_up_vel.y:
		camera.current_lerp_ratio.y = camera.lerp_ratio.y
	else: camera.current_lerp_ratio.y = lerp(camera.current_lerp_ratio.y, 1.0, 0.01)
	
	# Look-ahead management
	if abs(hero_vel.x) > camera.lookahead_activation_vel.x:
		camera.current_lookahead.x = lerp(camera.current_lookahead.x, la_amount.x*hero_dir, 0.1)
	else: camera.current_lookahead.x = lerp(camera.current_lookahead.x, 0.0, 0.1)
		
	if hero_vel.y > camera.lookahead_activation_vel.y:
		camera.current_lookahead.y = lerp(camera.current_lookahead.y, la_amount.y, 0.1)
	else: camera.current_lookahead.y = lerp(camera.current_lookahead.y, 0.0, 0.1)
	
	# Target acquisition
	camera.target = camera.hero.global_position + camera.current_lookahead
	for top_locker in camera.lockers:
		if top_locker.axes == Constants.Axes.x:
			camera.target.x = top_locker.lock_position.x 
			camera.current_lerp_ratio.x = camera.lerp_ratio.x
		elif top_locker.axes == Constants.Axes.y:
			camera.target.y = top_locker.lock_position.y
			camera.current_lerp_ratio.y = camera.lerp_ratio.y
		elif top_locker.axes == Constants.Axes.both:
			camera.target = top_locker.lock_position
			camera.current_lerp_ratio = camera.lerp_ratio
	
	# Move camera smoothly towards target
	camera.position = camera.lerp_vector2(camera.position, camera.target, camera.current_lerp_ratio)
	
func on_process_physics(delta: float):
	pass

func on_exit():
	pass
