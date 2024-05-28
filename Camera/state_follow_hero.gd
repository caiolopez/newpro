extends CameraState

var hero_real_vel: Vector2
var hero_vel: Vector2
var hero_dir: int
var last_hero_dir: int
var la_amount: Vector2
var la_timer: Timer


func on_enter():
	la_timer = get_node("../TimerBeforeLookaheadX")

func on_process(delta: float):
	hero_real_vel = c.hero.get_real_velocity()
	hero_vel = c.hero.velocity
	hero_dir = c.hero.facing_direction
	la_amount = c.lookahead_amount	
	
	# Lerp Lerp Smoothing
	if abs(hero_real_vel.x) < c.lerp_speed.x or last_hero_dir != hero_dir:
		c.current_lerp_speed.x = c.lerp_speed.x
	else: c.current_lerp_speed.x = lerp(c.current_lerp_speed.x, abs(hero_real_vel.x) * c.lerp_speed.x, Utils.dt_lerp(c.catch_up_speed.x, delta))
		
	if abs(hero_real_vel.y) < c.lerp_speed.y:
		c.current_lerp_speed.y = c.lerp_speed.y
	else: c.current_lerp_speed.y = lerp(c.current_lerp_speed.y, abs(hero_real_vel.y) * c.lerp_speed.y, Utils.dt_lerp(c.catch_up_speed.y, delta))
	
	# Look-ahead management
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or c.hero.just_stopped_pushing_wall:
		la_timer.start()
	
	if abs(hero_real_vel.x) > c.lookahead_activation_vel.x\
	and signf(hero_real_vel.x) == hero_dir\
	and not c.hero.is_pushing_wall():
		c.current_lookahead.x = lerp(la_amount.x * hero_dir, 0.0, la_timer.time_left)
	else:
		c.current_lookahead.x = lerp(c.current_lookahead.x, 0.0, clampf(10 * delta, 0, 1))

	if hero_vel.y > 0:
		c.current_lookahead.y = lerp(0.0, la_amount.y, minf(abs(hero_vel.y), c.lookahead_activation_vel.y) / c.lookahead_activation_vel.y)
	else: c.current_lookahead.y = lerp(c.current_lookahead.y, 0.0, clampf(10 * delta, 0, 1))
	
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
	c.position = c.lerp_vector2(c.position, c.target, c.current_lerp_speed, delta)
	
	c.step_shake(delta, c.position)
	
	last_hero_dir = hero_dir
	
func on_process_physics(_delta: float):
	pass

func on_exit():
	pass
