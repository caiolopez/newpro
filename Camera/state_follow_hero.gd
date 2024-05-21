extends CameraState

var hero_vel: Vector2
var hero_dir: int
var last_hero_dir: int
var la_amount: Vector2

func on_enter():
	pass

func on_process(delta: float):
	hero_vel = c.hero.get_velocity()
	hero_dir = c.hero.facing_direction
	la_amount = c.lookahead_amount
	
	
	# Lerp Lerp Smoothing
	if abs(hero_vel.x) < c.catch_up_vel.x or last_hero_dir != hero_dir:
		c.current_lerp_speed.x = c.lerp_speed.x
	else: c.current_lerp_speed.x = lerp(c.current_lerp_speed.x, 1.0, c.lerp_lerp_speed.x)
		
	if abs(hero_vel.y) < c.catch_up_vel.y:
		c.current_lerp_speed.y = c.lerp_speed.y
	else: c.current_lerp_speed.y = lerp(c.current_lerp_speed.y, 1.0, c.lerp_lerp_speed.y)
	
	# Look-ahead management
	if abs(hero_vel.x) > c.lookahead_activation_vel.x:
		c.current_lookahead.x = lerp(c.current_lookahead.x, la_amount.x*hero_dir, 0.1)
	else: c.current_lookahead.x = lerp(c.current_lookahead.x, 0.0, 0.1)
		
	if hero_vel.y > c.lookahead_activation_vel.y:
		c.current_lookahead.y = lerp(c.current_lookahead.y, la_amount.y, 0.1)
	else: c.current_lookahead.y = lerp(c.current_lookahead.y, 0.0, 0.1)
	
	# Target acquisition
	c.target = c.hero.global_position + c.current_lookahead
	for top_locker in c.lockers:
		if top_locker.axes == Constants.Axes.x:
			c.target.x = top_locker.lock_position.x 
			c.current_lerp_speed.x = c.lerp_speed.x
		elif top_locker.axes == Constants.Axes.y:
			c.target.y = top_locker.lock_position.y
			c.current_lerp_speed.y = c.lerp_speed.y
		elif top_locker.axes == Constants.Axes.both:
			c.target = top_locker.lock_position
			c.current_lerp_speed = c.lerp_speed
	
	# Move camera smoothly towards target
	c.position = c.lerp_vector2(c.position, c.target, c.current_lerp_speed)
	
	c.step_shake(delta, c.position)
	
	last_hero_dir = hero_dir
func on_process_physics(delta: float):
	pass

func on_exit():
	pass
