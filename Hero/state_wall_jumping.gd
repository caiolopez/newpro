extends HeroState

func on_enter():
	hero.velocity.x = hero.WALLJUMP_VELOCITY.x * round(hero.get_wall_normal().x)
	hero.velocity.y = hero.WALLJUMP_VELOCITY.y

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if not hero.is_on_floor() and hero.velocity.y > 0: machine.set_state("StateFalling")
	if Input.is_action_just_pressed('jump'): machine.set_state("StateJumping")
	if Input.is_action_pressed('jump') and not get_node("../TimerBufferJump").is_stopped():
		machine.set_state("StateJumping")


	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
