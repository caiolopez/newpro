extends CameraState

var la_timer: Timer

func on_enter():
	la_timer = get_node("../TimerBeforeLookaheadX")
	la_timer.start()

func on_process(delta: float):
	if not Utils.is_pushing_sides()\
	or not abs(c.hero_real_vel.x) > c.lookahead_activation_vel.x\
	or not signf(c.hero_real_vel.x) == c.hero_dir\
	or not c.hero.state_machine.current_state.death_prone\
	or c.last_hero_dir != c.hero_dir:
		machine.set_state("StateFollowHero")
		return
	
	c.step_catch_up(delta)
	c.step_lookahead_y(delta)
	c.current_lookahead.x = lerp(c.lookahead_amount.x * c.hero_dir, 0.0, la_timer.time_left)
	c.step_target_acquisition(delta)
	
	c.position = c.lerp_vector2(c.position, c.target, c.current_lerp_speed, delta)
	c.step_shake(delta, c.position)
