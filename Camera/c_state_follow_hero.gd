extends CameraState

var la_timer: Timer


func on_enter():
	la_timer = get_node("../TimerBeforeLookaheadX")


func on_physics_process(delta: float):
	if Utils.is_pushing_sides()\
	and abs(c.hero_real_vel.x) > c.lookahead_activation_vel.x\
	and not c.hero.is_pushing_wall()\
	and signf(c.hero_real_vel.x) == c.hero_dir:
		machine.set_state("CStateFollowLookaheadX")
	
	c.step_shake(delta)
	c.step_catch_up(delta)
	c.step_lookahead_y(delta)
	c.current_lookahead.x = lerp(c.current_lookahead.x, 0.0, clampf(10 * delta, 0, 1))
	c.step_camera_position(delta)
